# Test Yet Another Feature Page

!!! success "Version Selector Test Page"
    **This page only exists in the latest version (v1.15.0-test and newer)!**

    This page is used to test the version selector's fallback functionality.

## Purpose

This page helps verify that the version selector feature works correctly:

1. **Stay on page**: When switching between versions that both have this page, you should stay on this page.
2. **Fallback to homepage**: When switching from this page (v1.15) to an older version (v1.14, v1.13) that doesn't have it, you should be redirected to the homepage.

## How to Test

### Test 1: Fallback Behavior (Page doesn't exist in target version)

1. Make sure you're viewing this page in the `stable` or `v1.15` version
2. Open the version selector dropdown in the sidebar
3. Select an older version (`v1.14` or `v1.13`)
4. **Expected**: You should be redirected to the homepage of that version

### Test 2: Stay on Page (Page exists in both versions)

1. Navigate to any common page like `man/guide.html`
2. Use the version selector to switch between versions
3. **Expected**: You should stay on the same page in the new version

## Technical Details

The version selector JavaScript code:

- Extracts the current page path
- Constructs the target URL in the selected version
- Uses a `fetch()` HEAD request to check if the page exists
- If the page exists (HTTP 200), navigates to it
- If the page doesn't exist (HTTP 404), falls back to the homepage

This provides a better user experience compared to the old behavior which would always navigate to the homepage.
