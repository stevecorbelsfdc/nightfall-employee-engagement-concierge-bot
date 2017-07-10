var kbChatEngine = function () {

                // patterns that the engine can resolve
                var capabilities = [
                    "Ask what something is like 'What is DNA'?",
                    "Ask where something is like 'Where is China'?",
                    "Ask about a person like 'Who is Bill Gates'?",
                    "Say a movie/person/location name like 'Braveheart' to get information about that entity",
                    "Say a something like 'simpsons characters' to get information about that phrase",
                ];

                return {
                    react: function (query) {
                        
                            ChatBot.addChatEntry('KBEngine', "bot");
                            ChatBot.thinking(false);
                     
                    },
                    getCapabilities: function () {
                        return capabilities;
                    },
                    getSuggestUrl: function() {
                        return null;
                    }
                }
            }