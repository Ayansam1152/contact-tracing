({
    getWords : function(count) {

        if(count >100 ) return;

        let words = [
            "Apple",
            "Banana",
            "Cherry",
            "Dragon",
            "Elephant",
            "Forest",
            "Galaxy",
            "Harmony",
            "Iceberg",
            "Journey",
            "Kite",
            "Lemon",
            "Mountain",
            "Nebula",
            "Ocean",
            "Panda",
            "Quokka",
            "Rainbow",
            "Sunshine",
            "Tiger",
            "Umbrella",
            "Volcano",
            "Whistle",
            "Xylophone",
            "Yacht",
            "Zebra",
            "Atlas",
            "Breeze",
            "Canvas",
            "Dancer",
            "Echo",
            "Fable",
            "Glimmer",
            "Honey",
            "Island",
            "Jigsaw",
            "Kaleidoscope",
            "Laughter",
            "Melody",
            "Nucleus",
            "Oasis",
            "Puzzle",
            "Quiver",
            "Rocket",
            "Saffron",
            "Treasure",
            "Unicorn",
            "Vortex",
            "Wander",
            "X-ray",
            "Yonder",
            "Zenith",
            "Adventure",
            "Bubble",
            "Crystal",
            "Doodle",
            "Enigma",
            "Fairy",
            "Giraffe",
            "Hurdle",
            "Illusion",
            "Jumble",
            "Kettle",
            "Lantern",
            "Mirror",
            "Notebook",
            "Opal",
            "Prism",
            "Quench",
            "Riddle",
            "Sprout",
            "Tapestry",
            "Universe",
            "Velocity",
            "Whisper",
            "Xerox",
            "Yarn",
            "Zest",
            "Acorn",
            "Blossom",
            "Canyon",
            "Dewdrop",
            "Ember",
            "Feather",
            "Galaxy",
            "Hearth",
            "Inkwell",
            "Jewel",
            "Kingdom",
            "Leaf",
            "Meadow",
            "Nest",
            "Oracle",
            "Petal",
            "Quicksand",
            "Ripple",
            "Sphinx",
            "Tranquil",
            "Utopia",
            "Vivid"
          ];
          
        words = this.randomizeArray(words);
        return words.slice(0,count);
    },

    randomizeArray : function(array) {
        for (let i = array.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [array[i], array[j]] = [array[j], array[i]]; // Swap elements
        }
        return array;
    },

    getWinWord : function(arr) {
        let randomIndex = Math.ceil(Math.random() * 10);
        return arr[randomIndex];
    },

    disableBoard : function (component) {
        component.set("v.boardDisabled", true);
    },

    enableBoard : function (component) {
        component.set("v.boardDisabled", false);
    },
    
    resetBoard : function (component) {
        this.enableBoard(component);
        // reset move left
        component.set("v.clickCount",0);
        // reset result
        component.set("v.result","");
    }
})
