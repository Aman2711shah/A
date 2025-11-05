# Theme Switching Guide

## Overview

This guide explains the theme switching functionality that has been implemented in the WAZEET app. Users can now easily switch between light and dark modes, or let the app follow the system theme.

## Features

### Three Theme Modes

1. **Light Mode** ☀️
   - Always displays the app in light colors
   - Best for use in bright environments
   - Easy on the eyes during daytime

2. **Dark Mode** 🌙
   - Always displays the app in dark colors
   - Reduces eye strain in low-light environments
   - Saves battery on OLED screens

3. **System Default** 🔄
   - Automatically follows your device's theme setting
   - Switches between light and dark based on system preferences
   - Respects system-level dark mode schedules

### Theme Persistence

Your theme preference is automatically saved and will be remembered even after you close and reopen the app.

## How to Use

### Quick Toggle (Clubhouse Home Screen)

1. Look at the top-left corner of the home screen
2. You'll see a theme toggle button next to the time
3. Tap the button to instantly switch between light and dark modes
4. The icon changes based on current theme:
   - 🌙 Moon icon = Currently in light mode (tap to switch to dark)
   - ☀️ Sun icon = Currently in dark mode (tap to switch to light)

### Appearance Settings (Full Control)

1. From the home screen, tap the ⚙️ Settings icon in the top-right corner
2. This opens the Appearance Settings screen
3. You'll see three options:
   - **Light Mode**: Tap to always use light theme
   - **Dark Mode**: Tap to always use dark theme
   - **System Default**: Tap to follow device settings
4. You can also use the quick toggle switch at the bottom

### From Code (For Developers)

```dart
// Access the theme provider
final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

// Toggle between light and dark
await themeProvider.toggleTheme();

// Set specific theme mode
await themeProvider.setThemeMode(ThemeMode.light);
await themeProvider.setThemeMode(ThemeMode.dark);
await themeProvider.setThemeMode(ThemeMode.system);

// Check current theme
if (themeProvider.isDarkMode) {
  // Currently in dark mode
}
```

## Technical Details

### Architecture

The theme switching system is built using:
- **Provider Pattern**: For state management
- **Hive Storage**: For persistent theme preferences
- **Material 3**: Modern Flutter theming system

### Files Involved

- `lib/core/providers/theme_provider.dart` - Theme state management
- `lib/core/storage/local_storage.dart` - Persistent storage
- `lib/core/theme/app_theme.dart` - Theme definitions
- `lib/presentation/screens/settings/appearance_settings_screen.dart` - Settings UI

### Theme Definitions

Both light and dark themes are fully defined with:
- Custom color schemes
- Typography styles
- Component themes (buttons, cards, etc.)
- Modern Material 3 design

## Troubleshooting

### Theme Not Switching

If the theme doesn't switch when you tap the toggle:
1. Ensure you have the latest version of the app
2. Try using the Appearance Settings screen instead
3. Restart the app

### Theme Not Persisting

If your theme preference doesn't save:
1. Check that the app has storage permissions
2. Clear the app cache and try again
3. Reinstall the app if the issue persists

### System Mode Not Working

If System Default mode doesn't follow your device:
1. Check your device's dark mode settings
2. Ensure the app has permission to read system settings
3. Try switching to explicit Light or Dark mode instead

## Best Practices

### For Users

1. **Battery Saving**: Use Dark Mode to save battery on OLED devices
2. **Eye Comfort**: Switch to Dark Mode in low-light environments
3. **Consistency**: Use System Default to match other apps
4. **Accessibility**: Choose the theme that provides best contrast for your needs

### For Developers

1. Always test UI changes in both light and dark themes
2. Use theme colors instead of hardcoded colors
3. Test with System Default mode enabled
4. Ensure images and icons work in both themes

## Accessibility

The theme system supports:
- High contrast colors in both modes
- Proper text contrast ratios
- Large touch targets for theme controls
- Screen reader compatibility

## Future Enhancements

Possible future additions:
- Custom color schemes
- Scheduled theme switching (e.g., dark mode at night)
- Per-screen theme overrides
- Theme preview before applying
- Multiple theme variants

## Support

If you encounter any issues with theme switching:
1. Check this guide first
2. Review the Troubleshooting section
3. Contact support with details about:
   - Your device model and OS version
   - Steps to reproduce the issue
   - Screenshots if applicable

## Changelog

### Version 1.0.0
- ✅ Initial theme switching implementation
- ✅ Light, Dark, and System theme modes
- ✅ Quick toggle button on home screen
- ✅ Comprehensive appearance settings screen
- ✅ Persistent theme preferences
- ✅ Smooth theme transitions

---

**Note**: The theme you choose affects the entire app, including all screens, dialogs, and UI components. Choose the theme that works best for you!
