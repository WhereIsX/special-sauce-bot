# TODO
    - learn emacs to use crdt for collaboration!!! 
### PLUMBING
    - set ~/.ssh/
    - figure out a way to manage our 
        - .bashrc stuff, secrets.env stuff
        - FOR DISTRO HOPPING 
            - elementary
            - ??
    - learn docker 
    - figure out a way to manage the server
        - for when we want to shut down an instance 
        - and start up another instance 
            - etc


### PRIORITY -1
    
    3.5 yak queue that duckies can shepard into the penn and 
        - yana can shift the first yak off and shave it :> 
    6. bot timeout
        - "wanna become famous?"
        - "how fast can you type?"
        - the hoolians 


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
    - rename chatty => ??? 
        - group of ducks: raft, team, paddling 
            - floaties? 
            - duck raft? 
            - duck craft?
            - watty? 
            - quatty? 
            - dacraft? 
            - no ducks given 
            - the quack interloop 
            - wat the duck 
            - wat the bot 
            - fowlplay 
            - dumblequack
    - cooldown on commands 
    - tests 
    - log chat ??
        - stick reminders in profile && instead of PONG facts
    - give duckies titles!!! (table duckies column title)
        - also column ducksona 
    - whoami? --> all record holders get to see their own record
    - commands to be case insensitive
#### TBD COMMANDS
    - !wave -> return the wave emoji 
    - !ruffle
    - !munch
    - !quack
    - !<points> to <gryffindor/ravenclaw/slytherin/hufflepuff>  
    
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

#### POINTS
    - use channel points (nands) to redeem a care package! 
        - 5h/day * 5days/week * 50weeks/year = 1250 h/year 
            - #dimensional analysis
        - if we assume the average viewer gets 220 nands/h, 
            that's 275,000 nands/year if viewer watches ALL hours
            - which is unreasonable
        - 137,500 nands in exchange for (a carepackage || donate to charity)

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

