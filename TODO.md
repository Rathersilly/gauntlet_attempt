#TODO

there's gotta be a super simple way to add an animation

the game needs to know - what animation is playing, how long it lasts,
how long is left, the image path(s), the coords if needed

so could have a data structure

class Ent
  @current_anim  -> animation class


class Anim

  @path
  @max_time
  @cur_time

  @frame_dur
Ent#add_animation(args)
  @animations << Anim.new  


4/24/21
pretty sure after attacking I never reset status
i dont think that matters a lot at the moment, but statuses might become important later

