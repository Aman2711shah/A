# WAZEET Web Deployment Guide

## 🌐 Live Demo
Your application will be available at: **https://aman2711shah.github.io/A/**

## 📦 Deployment Methods

### Method 1: Automatic Deployment (GitHub Actions)
The application is set to automatically deploy to GitHub Pages whenever you push to the main branch.

**Setup Steps:**
1. Go to your GitHub repository: https://github.com/Aman2711shah/A
2. Navigate to **Settings** → **Pages**
3. Under "Source", select **GitHub Actions**
4. The workflow will automatically build and deploy your app

### Method 2: Manual Deployment (docs folder)
The built web files are already copied to the `docs/` folder.

**Setup Steps:**
1. Go to your GitHub repository: https://github.com/Aman2711shah/A
2. Navigate to **Settings** → **Pages**
3. Under "Source", select **Deploy from a branch**
4. Select branch: **main** and folder: **/docs**
5. Click **Save**

## 🔨 Building for Web

To build the web version locally:

```bash
# Build for production
flutter build web --release --base-href /A/

# Copy to docs folder for manual deployment
cp -r build/web/* docs/
```

## 🚀 Testing Locally

To test the web build locally:

```bash
# Install a simple HTTP server (if not already installed)
npm install -g http-server

# Or use Python
python3 -m http.server 8000 -d build/web

# Or use Flutter's built-in server
flutter run -d chrome
```

## 📝 Notes

- The base href is set to `/A/` to match your GitHub repository name
- All assets and routes are configured for GitHub Pages deployment
- The app uses the custom WAZEET branding with gold theme (#B8860B)

## 🔄 Updating the Deployment

After making changes to your Flutter app:

```bash
# Build the updated version
flutter build web --release --base-href /A/

# Copy to docs folder
cp -r build/web/* docs/

# Commit and push
git add .
git commit -m "Update web deployment"
git push origin main
```

The GitHub Actions workflow will automatically deploy the changes, or if using the docs folder method, the changes will be live within a few minutes.

## 🎨 Application Features

- Modern UI with WAZEET gold branding
- Custom logo with Dubai skyline
- Comprehensive AppColors theme system
- Business setup services
- Company formation tracking
- Growth services planning
- Community features

## 📱 Responsive Design

The application is optimized for:
- Desktop browsers
- Tablet devices
- Mobile browsers
- Progressive Web App (PWA) support

---

**Repository:** https://github.com/Aman2711shah/A
**Live URL:** https://aman2711shah.github.io/A/
