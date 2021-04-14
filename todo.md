# TODO
**steps to deply on gcp**
    1. modify `special-sauce-bot`: 
        - path 
            - ENV 
            - optional run args
        - remove tunneling pagekite service 
    1.5 move `last_leaked` (!leaked and !damn commands)
        - to sqlite3
    2. on vm
        - git `special-sauce-bot`
        - git twitch-cli 
        - set up ENV variables 
    3. get certificate for our domain 
        - get caddy? 
    3.5 set up `twitch` cli on google server  
    4. celebrate! 
    5. make the rest of the features 👇

### PRIORITY 0 
    - use granite!
        - make model 
            - manual test that we can use the model first :w
            - validations 
        - no more dblibrarian
            - make dynamic commands use new models 

        - clean up .sql files
    - does it compile?
    - ^ step 3: get certificate for website 
        - use caddy 
    - make own api calls
        - currently using command literal ("shelling out") `twitch api get` 
        - !so command depends on this
    - make yak table 
        - optional column: track yak topic
            - !yak_track <topic>
    - supercows should be a table :D 

### PRIORITY 1
    - tests 
    - log chat
        - stick reminders in profile && instead of PONG facts
    - give duckies titles!!! (table duckies column title)
        - also column ducksona 
    - whoami? --> all record holders get to see their own record
    - commands to be case insensitive 
#### TBD COMMANDS
    - !peas
        - returns the peas that a ducky has accumulated 
    - !feast <amount> <time_duration>
        - feed amount to all duckies who chatted in the last time_duration 
    - !stimulus_peas <amount>
        - feed amount to ALL duckies in record 
    - !trade_peas <reward>
        - but what rewards can we give the duckies??
    - !feedme <amount>
        - request to be fed <amount>
        - stored in a queue for yana to say approve/reject (y/n)
            - persisted on a table??
    - !gamble <amount/"all">
        - RNG? 
        - a duckie mentions that gambling is not allowed in many countries 
    - how to convert channel points (NANDs) -> peas 

### PRIORITY none aka never getting done  
    - make more emojis, subscribble badges 
    - say hi to new duckies! 
        - [] subscribe to twitch API for subscribbles -
    - https://dev.twitch.tv/docs/irc/guide#twitch-irc-capabilities tags and registration 
    - respond to @x_is_here bot
    - group channel point redemptions cooldown -> twitch api 
    - translate shit 
    - "want to become famous??"
    - optinal argv for commands.json path at beginning of run 


### PROJECTS ROADMAP
    - get to a "good enough" point with chatbot
    - duck pond 3js project 
    - TUI go + bubbletea + lipgloss
    - blog pawject
    - make follow/subscribble emotes and badges

### need a database(sqlite) for these
choose duck-sona (Aylesbury Duck) -> animate these! in duck pond(js)
when duckies use our emotes, we give them points?!
!feed all 
!feed < duck name >
    - how we give duckies points 

### need a NLP for these
SEMANTIC ANALYSIS!?

make another program, "What Would ____ Do?"
which is just bunch of commands => response
and it compiles this to a file.json
that chatty can reference?

