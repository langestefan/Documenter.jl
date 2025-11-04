#!/bin/bash

# Script to create test version tags for testing the version selector feature
# These are lightweight tags that won't affect your actual releases

set -e

echo "Creating test version tags for Documenter.jl..."
echo ""
echo "This will create the following tags:"
echo "  - v1.15.0-test (will be 'stable')"
echo "  - v1.14.0-test"
echo "  - v1.13.0-test"
echo ""
echo "These tags point to your current commit on stay-on-page-with-workflow branch"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Aborted."
    exit 1
fi

# Get current commit
COMMIT=$(git rev-parse HEAD)
echo ""
echo "Current commit: $COMMIT"
echo ""

# Create tags
echo "Creating tags..."
git tag -f v1.15.0-test
git tag -f v1.14.0-test
git tag -f v1.13.0-test

echo ""
echo "✅ Tags created locally!"
echo ""
echo "To push these tags and trigger documentation builds:"
echo ""
echo "  git push origin v1.15.0-test v1.14.0-test v1.13.0-test --force"
echo ""
echo "This will:"
echo "  1. Push the tags to GitHub"
echo "  2. Trigger 3 documentation builds (one for each tag)"
echo "  3. Documenter will automatically create version folders"
echo "  4. The latest tag (v1.15.0-test) will be set as 'stable'"
echo ""
echo "After all builds complete (~10-15 min), you can access:"
echo "  https://langestefan.github.io/Documenter.jl/stable/"
echo "  https://langestefan.github.io/Documenter.jl/v1.15/"
echo "  https://langestefan.github.io/Documenter.jl/v1.14/"
echo "  https://langestefan.github.io/Documenter.jl/v1.13/"
echo "  https://langestefan.github.io/Documenter.jl/dev/ (from branch)"
echo ""
echo "To clean up later:"
echo "  git push origin --delete v1.15.0-test v1.14.0-test v1.13.0-test"
echo "  git tag -d v1.15.0-test v1.14.0-test v1.13.0-test"
echo ""
