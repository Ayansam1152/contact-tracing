({
    startGame : function(component, event, helper) {
        // access comboBox here
        let gameModeComboBox = component.find("gameMode");
        
        // accessing the value of comboBox
        let selectedValue = gameModeComboBox.get("v.value")
        let selectedMode = component.get("v.selectedGameMode");

        component.set("v.selectedGameMode",selectedValue);
        if(selectedMode)
        {
            const boardComp = component.find("boardComp");
            boardComp.startGame();
        }

    },

    reShuffleBoard : function(component, event, helper) {
        console.log("Hello I am ReShuffle button");
    } 
})
