({
    doInIt : function(component, event, helper) {
        const gameMode = component.get("v.mode");
        let column = 0;

        if(gameMode && gameMode === "hard")
        {
            column = 6;
        }
        else if(gameMode === "medium")
        {
            column = 4;
        }
        else
        {
            column = 3;
        }

        let blockSize = 12/column;
        component.set("v.blockSize",blockSize);

        // we want 100 words
        let words = helper.getWords(column*column);
        component.set("v.words",words);
        // console win words
        let winWord = helper.getWinWord(words);
        component.set("v.winWord",winWord);

        helper.resetBoard(component);
    }
    ,
    doRender : function(component, event, helper) {
        console.log("Hello from Do Render working G");
    }
    ,

    blockClickHandler : function(component, event, helper) {
        let clickCount = component.get("v.clickCount") +1;
        const value = event.getParam("value");

        if(value === component.get("v.winWord"))
        {
            // You have Won :)
            component.set("v.result", "You Won :)");
            console.log("Yeah, won");
            helper.disableBoard(component);
        }
        else if(clickCount === 3)
        {
            // You have lost :(
            component.set("v.result", "You Lost :(");
            console.log("Yeah, Lost");
            helper.disableBoard(component);
        }

        component.set("v.clickCount", clickCount);
    }
})
