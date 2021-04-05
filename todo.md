# TODO
    - steps to deply on gcp
        1. modify `special-sauce-bot`: 
            - path 
                - ENV 
                - optional run args
            - remove tunneling pagekite service 
        1.5 move `last_leaked` (!leaked and !damn commands)
            - to sqlite3
        2. on vm: 
            - git `special-sauce-bot`
            - git twitch-cli 
            - set up ENV variables 
        3. get certificate for our domain 
            so that twitch will hit us up
        4. celebrate! 
        5. make the rest of the features 👇
    - start delegating to an actual ORM instead of hackshacking our way around a fake ORM that eats up our time and makes us learn SQL for no good reason and we can't even flipping think straight anymore.
    - actually make the yak table and decide on a good-enough start (which columns)
    - decide on what to keep from twitch chat logs and how we should inform our viewers that this is being kept. (#consent_is_sexy) 
        - instead of returning PONG facts, one of the things we can return is the reminder that chat is logged 
            - worried that viewers will restrict speech / self censor and make this a sad space :(
    - stop delegating to twitch-cli
        => make our own APIcalls 
    - change table name duckies -> ducky (singular)
    - clean up .sql files
    - !pond_points :>  
    - !counter_start <name> 
    - !++ <counter_name>
    - !-- <counter_name> 
    - tests 
    - supercows should be a table :D 
    - whoami? --> all record holders get to see their own record
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

