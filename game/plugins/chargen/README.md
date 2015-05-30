Chargen Plugins
====

AresMUSH features a full-fledged Character Creation (Chargen) system.  Although it comes set up for the FS3 Skills System out of the box, it can be adapted to other systems with modest code changes.

The Ares chargen system consists of three components:

Chargen Tutorial and Stages
---------------------

You can configure the **stages** or steps of chargen.  Each stage will display a combination of a tutorial screen or a helpfile from the [[[plugin:Help]]] system (or both!).  The chargen system tracks which stage you're in, so you can lock down commands so they only work in certain stages.  You can also setup code to make sure they've set the necessary things before allowing them to proceed to the next step.

    +==~~~~~====~~~~====~~~~====~~~~=====~~~~=====~~~~====~~~~====~~~~====~~~~~==+
    Character creation (aka chargen) here works a little differently than what you might be used to from other games.  Instead of being a series of rooms, the cg command will walk you through the necessary steps.  
    
    You can go back and forth through the steps of chargen using cg/next and cg/prev.  Going back is always allowed, but when you go forward - the game may check to make sure you've done what you needed to do in that step.
    ------------------------------------------------------------------------------
                                                                       cg/next -->
    +==~~~~~====~~~~====~~~~====~~~~=====~~~~=====~~~~====~~~~====~~~~====~~~~~==+

Background Commands
---------------------

The chargen plugin includes commands to set your character's background/bio.

Application Review
---------------------

Chargen ties in with the [[[plugin:Jobs]]] system to allow players to submit their character applications for review.  Both players and admin can view an app review summary, highlighting potential issues with the app at a glance.

    +==~~~~~====~~~~====~~~~====~~~~=====~~~~=====~~~~====~~~~====~~~~====~~~~~==+
    App Review for Faraday
    
    ------------------------- Abilities (help abilities) -------------------------
    25 total points spent. (60 max)                    < OK! >
    8 points spent on attributes. (12 max)             < OK! >
    11 points spent on action skills. (32 max)         < OK! >
    
    1 background skills added. (4 min)                 < Not Enough! >
    0 abilities over rating 7.  (3 max)                < OK! >
    2 quirks added. (2 min, 4 max)                     < OK! >
    
    Checking attributes all have a rating.             < OK! >
    Checking for starting languages.                   < OK! >
    Checking for starting skills.                      < OK! >
    
    ---------------------- Demographics (help demographics) ----------------------
    Checking all demographics are set.                 < OK! >
    
    ---------------------------- Groups (help groups) ----------------------------
    Checking groups are set.                           < OK! >
    
    --------------------- Miscellaneous (help bg, help desc) ---------------------
    Checking that you have a background.               < OK! >
    Checking you have a description set.               < OK! >
    Checking for valid rank.                           < Invalid Rank >
    
    ----------------------------- Review (help apps) -----------------------------
    Application not yet started.
    
    Red issues will probably hold up your app.
    Yellow may be OK if it suits your character.
    +==~~~~~====~~~~====~~~~====~~~~=====~~~~=====~~~~====~~~~====~~~~====~~~~~==+
