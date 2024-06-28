alsa_monitor.properties = {
  ["alsa.reserve"] = true,                -- Reserve devices via org.freedesktop.ReserveDevice1 on D-Bus
  ["alsa.midi"] = true,                   -- Enable MIDI functionality
  ["alsa.midi.monitoring"] = true,        -- Enable monitoring of ALSA MIDI devices
}

-- Define rules for ALSA devices and outputs
alsa_monitor.rules = {
  {
    matches = {
      {
        { "device.name", "matches", "alsa_card.*" },  -- Match all ALSA cards
      },
    },
    apply_properties = {
      ["api.acp.auto-profile"] = false,   -- Disable automatic profile selection
      ["api.acp.auto-port"] = false,      -- Disable automatic port selection
    },
  },
  {
    matches = {
      {
        { "node.name", "matches", "alsa_output.pci-0000_00_1f.3.hdmi-stereo" },  -- Match HDMI stereo output
      },
    },
    apply_properties = {
      ["node.description"] = "HDMI Output",  -- Set node description
      ["priority.driver"] = 100,           -- Set high driver priority
      ["priority.session"] = 100,          -- Set high session priority
    },
  },
  {
    matches = {
      {
        { "node.name", "matches", "alsa_output.*" },  -- Match all ALSA outputs
      },
    },
    apply_properties = {
      ["priority.driver"] = 50,            -- Set medium driver priority
      ["priority.session"] = 50,           -- Set medium session priority
    },
  },
}

