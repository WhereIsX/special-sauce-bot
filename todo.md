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
    - add to "rules" before users engage in chat that 
        their chatter will be logged by where_is_x
    log all chat 
    - 
    bot timeout
    - "wanna become famous?" 
        - levenshetin distance 
    - "how fast can you type?"
    - the hoolians 


### PRIORITY 0 
    - servy uses channel to communicate with chatty 
        - audogmagically shoutout raider :> 
    - clean up .sql files


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
    - !water add cooldown, gives peas
    - !bribe
    -  !hack DB.open my-db.db { |db| db.exec "DROP DATABASE;" } => "destroying data... deleting database... D̷̈́̎A̷͛̋T̸̈́̒A̵̓͠ ̷̛͆Ĕ̷̑R̴͐̈́R̸̄̉Õ̵͓Ȑ̸̑"
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

