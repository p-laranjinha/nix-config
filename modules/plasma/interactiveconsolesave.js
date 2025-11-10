var allPanels = [panels()[0]];
for (var panelIndex = 0; panelIndex < allPanels.length; panelIndex++) {
    var p = allPanels[panelIndex];
    print(p);

    var widgets = p.widgets();
    for (var widgetIndex = 0; widgetIndex < widgets.length; widgetIndex++) {
        var w = widgets[widgetIndex];
        print("\n  " + w.type + ": ");

        var configGroups = w.configGroups.concat([]); // concat is used to clone the array
        for (var groupIndex = 0; groupIndex < configGroups.length; groupIndex++) {
            var g = configGroups[groupIndex];
            print("\n    " + g + ": ");
            w.currentConfigGroup = [g];

            for (var keyIndex = 0; keyIndex < w.configKeys.length; keyIndex++) {
                var configKey = w.configKeys[keyIndex];
                print("\n      " + configKey + ": " + w.readConfig(configKey));
            }
        }
        print("\n\n");
    }
    print("\n\n\n\n");
}

w = panels()[0].widgets()[0]
w.currentConfigGroup = ["org.kde.ksysguard.linechart", "General"]
print(Object.keys(w))
print("\n\n");
print(JSON.stringify(w))
print("\n\n");
print(w.readConfig("rangeToY"))
