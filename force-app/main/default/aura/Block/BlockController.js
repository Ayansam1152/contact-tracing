({
    blockClickHandler : function(component, event, helper) {
        const open = component.get("v.open");

        if(!open)
        {
            component.set("v.open", true);
        }
        let label = component.get("v.label");

        let compEvent = component.getEvent("onClick");
        compEvent.setParams({value : label});
        compEvent.fire();
    }
})
