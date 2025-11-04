function maybeAddWarning() {
  // DOCUMENTER_NEWEST is defined in versions.js, DOCUMENTER_CURRENT_VERSION and DOCUMENTER_STABLE
  // in siteinfo.js. DOCUMENTER_IS_DEV_VERSION is optional and defined in siteinfo.js.
  // If the required variables are undefined something went horribly wrong, so we abort.
  if (
    window.DOCUMENTER_NEWEST === undefined ||
    window.DOCUMENTER_CURRENT_VERSION === undefined ||
    window.DOCUMENTER_STABLE === undefined
  ) {
    return;
  }

  // Abort if current version is not a semantic version (e.g., "v1.16")
  if (!/v(\d+\.)*\d+/.test(window.DOCUMENTER_CURRENT_VERSION)) {
    return;
  }

  // No warning if this is the newest version
  if (window.DOCUMENTER_NEWEST === window.DOCUMENTER_CURRENT_VERSION) {
    return;
  }

  // Add <meta name="robots" content="noindex"> if not already present
  if (document.body.querySelector('meta[name="robots"]') === null) {
    const meta = document.createElement("meta");
    meta.name = "robots";
    meta.content = "noindex";
    document.getElementsByTagName("head")[0].appendChild(meta);
  }

  // Create main overlay
  const div = document.createElement("div");
  div.classList.add("warning-overlay-base");

  const closer = document.createElement("button");
  closer.classList.add("outdated-warning-closer", "delete");
  closer.addEventListener("click", () => document.body.removeChild(div));

  // Determine current page and base URLs
  const currentPage = window.location.pathname;
  let docUrl = window.location.href;
  if (docUrl.endsWith("/")) docUrl += "index.html";

  // Resolve documenterBaseURL (relative path) to absolute
  const baseUrlAbsolute = new URL(
    window.documenterBaseURL,
    docUrl
  ).pathname.replace(/\/?$/, "/");

  // Extract path relative to version root
  const pagePath = currentPage.startsWith(baseUrlAbsolute)
    ? currentPage.substring(baseUrlAbsolute.length)
    : "";

  // Construct target base URL for the stable (or dev) version
  const targetHrefRelative = `${window.documenterBaseURL}/../${window.DOCUMENTER_STABLE}/`;
  const targetHref = new URL(targetHrefRelative, docUrl).href;

  // Construct full target URL preserving page path
  let targetUrl = targetHref;
  if (pagePath && pagePath !== "" && pagePath !== "index.html") {
    targetUrl = targetUrl.replace(/\/$/, "") + "/" + pagePath;
  }

  // Determine warning type
  let warningMessage = "";
  if (window.DOCUMENTER_IS_DEV_VERSION === true) {
    div.classList.add("dev-warning-overlay");
    warningMessage =
      "This documentation is for the <strong>development version</strong> and may contain unstable or unreleased features.<br>";
  } else {
    div.classList.add("outdated-warning-overlay");
    warningMessage =
      "This documentation is for an <strong>older version</strong> that may be missing recent changes.<br>";
  }

  // Create the “Go to stable version” link
  const link = document.createElement("a");
  link.href = targetHref;
  link.textContent =
    "Click here to go to the documentation for the latest stable release.";

  link.addEventListener("click", (event) => {
    event.preventDefault();
    // Check if same page exists in the target version
    fetch(targetUrl, { method: "HEAD" })
      .then((response) => {
        if (response.ok) {
          window.location.href = targetUrl;
        } else {
          window.location.href = targetHref;
        }
      })
      .catch(() => {
        window.location.href = targetHref;
      });
  });

  const paragraph = document.createElement("span");
  paragraph.innerHTML = warningMessage;

  div.appendChild(paragraph);
  div.appendChild(link);
  div.appendChild(closer);
  document.body.appendChild(div);
}

// Run on DOM ready
if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", maybeAddWarning);
} else {
  maybeAddWarning();
}
