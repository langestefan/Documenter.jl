#!/bin/bash

# Script to set up a test environment for the version selector feature
# This creates multiple version directories to simulate a deployed documentation site

echo "Setting up test environment for version selector..."

# Create the test directory structure
TEST_DIR="build_test"
cd "$(dirname "$0")"

# Remove old test directory if it exists
rm -rf "$TEST_DIR"

# Create version directories
echo "Creating version directories..."
mkdir -p "$TEST_DIR"/{stable,dev,v1.14,v1.13}

# Copy the built documentation to each version directory
echo "Copying build to version directories..."
if [ -d "build" ]; then
    cp -r build/* "$TEST_DIR/stable/"
    cp -r build/* "$TEST_DIR/dev/"
    cp -r build/* "$TEST_DIR/v1.14/"
    cp -r build/* "$TEST_DIR/v1.13/"
else
    echo "Error: build directory not found. Run 'julia --project=. make.jl' first."
    exit 1
fi

# Create a versions.js file at the root of build_test
echo "Creating versions.js file..."
cat > "$TEST_DIR/versions.js" << 'EOF'
var DOC_VERSIONS = [
  "stable",
  "dev",
  "v1.14",
  "v1.13",
];
EOF

# Update the versions.js reference in each version's siteinfo.js
for version in stable dev v1.14 v1.13; do
    if [ -f "$TEST_DIR/$version/siteinfo.js" ]; then
        # Update DOC_VERSIONS in each siteinfo.js
        cat > "$TEST_DIR/$version/siteinfo.js" << EOF
var DOCUMENTER_CURRENT_VERSION = "$version";
var DOC_VERSIONS = [
  "stable",
  "dev", 
  "v1.14",
  "v1.13",
];
EOF
    fi
done

echo "========================================="
echo "Test environment created successfully!"
echo "========================================="
echo ""
echo "To test the version selector:"
echo "1. Start a local server:"
echo "   cd $TEST_DIR && python3 -m http.server 8000"
echo ""
echo "2. Open in browser:"
echo "   http://localhost:8000/stable/index.html"
echo ""
echo "3. Test the version selector:"
echo "   - Navigate to different pages (e.g., man/guide.html)"
echo "   - Switch versions using the dropdown"
echo "   - Should stay on the same page if it exists"
echo "   - Should redirect to homepage if page doesn't exist"
echo ""
echo "4. Test fallback with the special test page:"
echo "   - Navigate to: http://localhost:8000/stable/test-new-page.html"
echo "   - Switch to dev, v1.14, or v1.13"
echo "   - Should redirect to homepage (page doesn't exist in those versions)"
