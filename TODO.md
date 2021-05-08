#TODO


5/8/21
Adding new ents is a mess - but it's already solved wrt icemissile.
just need to make subclasses of ent for hero etc
then can make more of them
also super important to get rid of all those Hash#find functions ugh

simple things to add

- hitpoints
- collision on projectile
- damage on projectile
- ui


- move unit data to xml files
- after ent class refactor/xml change, should be super simple to add new units/projectiles

a bit later - research how to make a map
- divide space into grid, look into pathfinding
- make pathfinding optional/toggleable. original gauntlet didnt have pathfinding

"components have no functions, systems have no fields" - timothy ford
a component can be marked read-only to a system, so multiple systems can read in parallel



