#pragma once

#include "PluginProcessor.h"

//==============================================================================
class ${PLUGIN_CLASS_NAME}AudioProcessorEditor  : public juce::AudioProcessorEditor
{
public:
    explicit ${PLUGIN_CLASS_NAME}AudioProcessorEditor (${PLUGIN_CLASS_NAME}AudioProcessor&);
    ~${PLUGIN_CLASS_NAME}AudioProcessorEditor() override;

    //==============================================================================
    void paint (juce::Graphics&) override;
    void resized() override;

private:
    // This reference is provided as a quick way for your editor to
    // access the processor object that created it.
    ${PLUGIN_CLASS_NAME}AudioProcessor& processorRef;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (${PLUGIN_CLASS_NAME}AudioProcessorEditor)
};
