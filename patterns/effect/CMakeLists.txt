cmake_minimum_required(VERSION 3.15 FATAL_ERROR)

# project name
project("${PLUGIN_PROJECT_NAME}" VERSION 0.0.1)

add_subdirectory(JUCE)

juce_add_plugin("${PLUGIN_CLASS_NAME}"
    # VERSION ...                               # Set this if the plugin version is different to the project version
    # ICON_BIG ...                              # ICON_* arguments specify a path to an image file to use as an icon for the Standalone
    # ICON_SMALL ...
    # COMPANY_NAME ...                          # Specify the name of the plugin's author
    # IS_SYNTH TRUE/FALSE                       # Is this a synth or an effect?
    # NEEDS_MIDI_INPUT TRUE/FALSE               # Does the plugin need midi input?
    # NEEDS_MIDI_OUTPUT TRUE/FALSE              # Does the plugin need midi output?
    # IS_MIDI_EFFECT TRUE/FALSE                 # Is this plugin a MIDI effect?
    # EDITOR_WANTS_KEYBOARD_FOCUS TRUE/FALSE    # Does the editor need keyboard focus?
    # COPY_PLUGIN_AFTER_BUILD TRUE/FALSE        # Should the plugin be installed to a default location after building?
    PLUGIN_MANUFACTURER_CODE Acids              # A four-character manufacturer id with at least one upper-case character
    PLUGIN_CODE AxAx                            # A unique four-character plugin id with at least one upper-case character
    FORMATS AU VST3 Standalone                  # The formats to build. Other valid formats are: AAX Unity VST AU AUv3
    PRODUCT_NAME "Acids Plugin")        # The name of the final executable, which can differ from the target nam

target_sources("${PLUGIN_CLASS_NAME}" PRIVATE
    PluginEditor.cpp
    PluginProcessor.cpp)

set_property(TARGET "${PLUGIN_CLASS_NAME}" PROPERTY CXX_STANDARD 14)
target_compile_definitions("${PLUGIN_CLASS_NAME}"
    PUBLIC
    # JUCE_WEB_BROWSER and JUCE_USE_CURL would be on by default, but you might not need them.
    JUCE_WEB_BROWSER=0  # If you remove this, add `NEEDS_WEB_BROWSER TRUE` to the `juce_add_plugin` call
    JUCE_USE_CURL=0     # If you remove this, add `NEEDS_CURL TRUE` to the `juce_add_plugin` call
    JUCE_VST3_CAN_REPLACE_VST2=0)

find_package(Torch REQUIRED)
target_link_libraries("${PLUGIN_CLASS_NAME}" PRIVATE
    # AudioPluginData           # If we'd created a binary data target, we'd link to it here
    juce::juce_audio_utils "${TORCH_LIBRARIES}")

#set_property(TARGET "${ACIDS_EXEC_NAME}" PROPERTY CXX_STANDARD 14)

#add_executable("${ACIDS_EXEC_NAME}" main.cpp)

