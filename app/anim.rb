class Anim
  attr_accessor :path, :cur_frame,:frames, :loop
  attr_accessor :frame_index, :name, :frames_per_sprite,:max_frames

  def initialize(args)
    @name = args[:name]
    @frames = []

    @path = args[:path]
    if @path
      @frames << @path
    end
    @cur_frame = 0
    @frames_per_sprite = 10
    @max_frames = @frames_per_sprite * @frames.size
    @frame_index = 0
    @loop = false
    @duration = 0

  end
  def duration= dur
    @duration = dur
    @frames_per_sprite = @duration / frames.size
    puts "DUR SET TO #{@frames_per_sprite}"
  end
  def current_sprite
    frames[frame_index]
  end

  def frame
    # returns the frame to be drawn (in Ent class)
    if frames.size == 1
      return frames[0]
    end

    # incrementing cur_time first, so that can check modulsu without worrying about 0 % n
    @cur_frame += 1

    # handle if cur = max - return nil or reset?
    if cur_frame > max_frames
    end

    if  cur_frame % frames_per_sprite == 0
      # if this says frame_index (without @), it doesnt update
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
    #dbinspect
    return frames[frame_index]
  end

  def show_info args
    args.outputs.labels << [100,650,"frame_index: #{frame_index}",2]
    args.outputs.labels << [100,620,"cur_frame: #{cur_frame}",2]
    args.outputs.labels << [100,590,"max_frame: #{max_frames}",2]
    args.outputs.labels << [100,560,"path: #{frames[frame_index]}",2]
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

