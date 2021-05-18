#TODO - actually its turned into more of a devlog

##5/8/21
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

##5/9/21
converted the init functions into Factory classes
each ent now has max 1 xform/anim at a time
got rid of a bunch of finds and rejects, saved like 8 fps but more work needed
skipping the cleanup step saves 5fps, as long as theres no missiles

- more refactoring to do - created spell_id. separate set of components, to stop from
having to iterator over a ton of nils all the time - not sure if worth

- there's a bug with a nil anim on a missile - need to give spells a duration

##5/10/21
refactored animation class to be more component like - everything still works but still
about 45 fps.  reading dragonruby's stdout perf tips will help - also docs

refactored loop through anims to use outputs.sprites << ... .each
as recommended. got rid of 20 draw calls but fps still at 45

want to try different way of storing animation frames in state
oh wtf checkout Numeric#frame_index
wait and why on earth are you storing all the paths in an array - you just need to know
their indexes

##5/13/21
with 50 steelclads, currently get 25 fps (this is benchmark before refactor)
this is with Animation being the only running system

1: change Anim frames array into a path and a number of frames
  Tried this - changed render function to use Numeric#frame_index
  aaaand lost 3 fps

2: tried changing AnimationSystem#Calc_sprites to just a calc_sprite function, 
   to save looping through anims an extra time - had 0 noticeable effect

##5/14/21
ok this separation of normal entities and spells is not gonna work - its not dry 
and its confusing af, at least in its current implementation

probably best to just look up components by id, rather than have separate arrays
of xforms/anims that are looked up by index = entity_id

SUCCESS: refactored things so there's a ComponentStore class, and can have multiples
of them, and limit the number of components in them (ie limit spells for perf)
fps is still not great in vm, but foundation is now solid i think

TODO: blocks, map, collision, damage, etc etc
oh, also the ne animations

##5/15/21
fixed anim component so upward animations work again!

-settled on 4 main Classes so far
  0. Entity
    - imaginary class: an entity_id(integer) that links many components
  1. Game/World/Scene
    - probably rename World
    - is mainly a container for systems
    - has tick function that calls those systems
  2. Component
    - building blocks for entities (which are just an integer)
    - goal is for these to ONLY have data needed for systems to function
    - extra misc data/functions should be moved to helpers of some type
  3. Systems
    - manipulate groups of components
    - only methods, no fields (for sure none that carry state)
  4. Factories
    - used to initialize Entities

  sill remaining - class to initialize systems? or is that just World

  OH, theres also 

  - ComponentStore - each ComponentStore has its own incrementing entity_id
  and its own container of components, which are accessed by index = entity_id
  this MIGHT make it more performant, we'll see!

renamed ComponentStore to ComponentRegistry
program structure is really looking nicer now, however still get only 20fps with
myriad other changes
50 steelclads

TODO: created input component, have to populate it
still gotta learn maps stop putting it off

##5/16/21
in starting to make map, realize ComponentRegistries do not need to iterate through each component type
they should be initialized with the component types they need, and perhaps have a separate hash
of components to iterate through if needed

another big refactor complete - registries are now initialized with a view - the
components that it has access to. @view is a hash of arrays of components, where
index = entity_id

So ComponentRegistry needs to reveal the the components it holds
Systems need to compare that to the components it affects/requires.
Systems @requires could be split up into @reads and @writes.  things that are only read
could be threaded

##5/17/21
ok some mega success! 3+ days of 6 hour refactoring sessions has paid off!
adding new systems and components should be so smooth now, although it will take 
practice to get fast at it

added collision class - it currently shares xform of parent

TODO - dry out factories - possibly rename factory to entity
need to have big behavior rewrite - behavior should perform collisions
need to collide things with things in other registries
need to set collision types in World class
is collision a subsystem of behavior? should subsystems be a thing?












#"components have no functions, systems have no fields" - tim ford
a component can be marked read-only to a system, so multiple systems can read in parallel

ok so how does the behavior component work?
the behavior system calls the functions, which exist in behavior components
ie functions functioning as state? interesting



