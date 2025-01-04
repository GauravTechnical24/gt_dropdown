# gt_dropdown

`gt_dropdown` is a highly customizable and feature-rich dropdown widget for Flutter, offering seamless integration with forms, validation, animations, and extensive styling options.

## Features

 - Fully customizable dropdown and menu appearance, including colors, borders, text styles, and border radius.
 - Built-in validation with customizable error messages and styles for seamless form integration.
 - Smooth animations for opening and closing the dropdown menu, enhancing user experience.
 - Supports hover effects and highlights the selected item for better user interaction.
 - Optionally add dividers between dropdown items for improved visual separation and clarity.

## Getting started

To use this package, add gt_dropdown as a dependency in your pubspec.yaml file.

## Usage

Minimal example:

```dart
     GTDropdown<String>(
                    items: const ['Option 1', 'Option 2', 'Option 3'],
                  )
```

Custom settings:

```dart
  GTDropdown<String>(
                    items: const ['Option 1', 'Option 2', 'Option 3'],
                    dropdownBorderRadius: BorderRadius.circular(8),
                    dropdownBorderColor: Colors.greenAccent,
                    menuBorderRadius: BorderRadius.circular(8),
                    menuBorderColor: Colors.green,
                    highlightSelectedItem: true,
                    selectedHighlightTextStyle: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                    selectedItemColor: Colors.blue.shade100,
                    validator: (value) => value != null,
                    validationMessage: 'Please select an option',
                    errorBorderColor: Colors.red,
                    name: 'dropdown1', // Optional: for identification
                  )
```

## See also

 - [linkedin](https://www.linkedin.com/in/gauravtechnical24/)
