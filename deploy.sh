#!/bin/sh
# deploy.sh

set -e

echo "Building Flutter web app..."
# Added --no-wasm-dry-run to suppress the harmless WebAssembly compatibility warnings.
flutter build web --release --base-href "/genet-church-live-demo/" --no-tree-shake-icons --no-wasm-dry-run

echo "Navigating to build directory..."
cd build/web

# Initialize git repository if not already present (though we rm -rf it at the end)
git init
git add -A
git commit -m "Deploy to GitHub Pages: $(date)"

echo "Deploying to gh-pages branch..."
git push -f https://github.com/HundefraN/genet-church-live-demo.git main:gh-pages

cd -
rm -rf build/web/.git

echo "Deployment complete!"