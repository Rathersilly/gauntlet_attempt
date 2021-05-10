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
- just make sure the new ent subclasses respect ECS

a bit later - research how to make a map
- divide space into grid, look into pathfinding
- make pathfinding optional/toggleable. original gauntlet didnt have pathfinding
- some of gauntlet's strategies were contingent on exploiting lack of pathfinding

- can analyse the loops in behavior function - dont need to iterate so many times

5/9/21
converted the init functions into Factory classes
each ent now has max 1 xform/anim at a time
got rid of a bunch of finds and rejects, saved like 8 fps but more work needed
skipping the cleanup step saves 5fps, as long as theres no missiles

- more refactoring to do - created spell_id. separate set of components, to stop from
having to iterator over a ton of nils all the time - not sure if worth

- there's a bug with a nil anim on a missile - need to give spells a duration

5/10/21
refactored animation class to be more component like - everything still works but still
about 45 fps.  reading dragonruby's stdout perf tips will help - also docs

refactored loop through anims to use outputs.sprites << ... .each
as recommended. got rid of 20 draw calls but fps still at 45





#"components have no functions, systems have no fields" - timothy ford
a component can be marked read-only to a system, so multiple systems can read in parallel

ok so how does the behavior component work?
the behavior system calls the functions, which exist in behavior components
ie functions functioning as state? interesting



