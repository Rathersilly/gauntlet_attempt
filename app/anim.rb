class Anim
  attr_accessor :path, :frames, :loop, :linger,:xoff,:yoff,:timeoff
  attr_accessor :name, :state,:max_frames, :parent

  def initialize(traits)
    @state = :off   # can be on or off or remove  # state will determine if anim needs to be removed

    # need a way to get x and y of the guy it's related to



    # these are offsets that can be used by the draw function
    @xoff = traits[:xoff]
    @yoff = traits[:yoff]
    @xoff ||= 0
    @yoff ||= 0
    @timeoff = traits[:timeoff]
    @timeoff ||= 0

    @name = traits[:name]
    @frames = []

    @path = traits[:path]
    if @path
      @frames << @path
    end
    @cur_frame = 0
    @frames_per_sprite = 10
    @max_frames = @frames_per_sprite * @frames.size
    @frame_index = 0
    @loop = false
    @linger = false       # remain on last fram after animation over
    @linger_dur = -1
    @fallback_animation   # what to do when animation finished - prob bad place for it
    @duration = 0

  end

  def attach parent
    self.parent = parent
  end

  def draw args
    args.outputs.sprites << [parent.x+xoff,parent.y+yoff,frames[frame_index]]
  end

  def duration= dur
    @duration = dur
    @frames_per_sprite = @duration / frames.size
    puts "DUR SET TO #{@frames_per_sprite}"
  end
  
  def current_sprite
    frames[frame_index]
  end

  def update
    # get next frame. handle if anim over
    if frames.size == 1
      return frames[0]
    elsif @linger == true && @cur_frame == @frames.size - 1
      return frames[-1]
    end

    # incrementing cur_time first, so that can check modulsu without worrying about 0 % n
    @cur_frame += 1

    # handle if cur = max - return nil or reset?
    if cur_frame > max_frames
    end

    if cur_frame % frames_per_sprite == 0
      @frame_index += 1
    end
    
    # good place to check bounds
    if @frame_index > @frames.size - 1
      if @loop == true
        reset
      else
        reset
        return nil
      end
    end

    # return the sprite to use
    @frame_index
  end

  def show_info args, x=100,y=560
    args.outputs.labels << [x,y+60,"frame_index: #{frame_index}",2]
    args.outputs.labels << [x,y+40,"cur_frame: #{cur_frame}",2]
    args.outputs.labels << [x,y+20,"max_frame: #{max_frames}",2]
    args.outputs.labels << [x,y,"path: #{frames[frame_index]}",2]
  end

  def reset
    @frame_index = 0
    @cur_frame = 0
  end 

  def dbinspect
    instance_variables.each do |var|
      puts "#{var}:\t\t#{instance_variable_get(var)}"
    end
  end
end

