// Optimized fader that only takes left channel into account

#include "DSPBase.h"
#include "ParameterRamper.h"

enum MonoFaderParameter : AUParameterAddress {
    MonoFaderParameterGain
};


struct MonoFaderDSP : DSPBase {
private:
    ParameterRamper gainRamp{1.0};

public:
    MonoFaderDSP() : DSPBase(1, true) {
        parameters[MonoFaderParameterGain] = &gainRamp;
    }

    // Uses the ParameterAddress as a key
    void setParameter(AUParameterAddress address, AUValue value, bool immediate) override {
        switch (address) {
            default:
                DSPBase::setParameter(address, value, immediate);
        }
    }

    // Uses the ParameterAddress as a key
    float getParameter(AUParameterAddress address) override {
        switch (address) {
            default:
                return DSPBase::getParameter(address);
        }
    }

    void startRamp(const AUParameterEvent &event) override {
        auto address = event.parameterAddress;
        switch (address) {
            default:
                DSPBase::startRamp(event);
        }
    }

    void process(FrameRange range) override {
        for (auto i : range) {

            float leftIn = inputSample(0, i);

            float& leftOut = outputSample(0, i);

            float gain = gainRamp.getAndStep();

            leftOut = leftIn * gain;

        }
    }
};

AK_REGISTER_DSP(MonoFaderDSP, "mfdr")
AK_REGISTER_PARAMETER(MonoFaderParameterGain)
