# palette:
def colorhex(str)
  color = []
  color << str[0..1].hex
  color << str[2..3].hex
  color << str[4..5].hex
end
Darkblue = colorhex('264653')
Green = colorhex('2a9d8f')
Yellow = colorhex('e9c46a')
Orange = colorhex('f4a261')
Red = colorhex('e76f51')
Colors = [Darkblue,Green,Yellow,Orange,Red]

Gsize = 80        # size of squares in game grid

module Init
  def make_board args
    return unless args.state.board.nil?
    args.state.board = []
    # 1280/80 = 16
    # 720/80 = 9
    (1..14).each do |i|
      (1..7).each do |j|
        x = Square.new(i,j,Gsize,Gsize, Yellow)
        p x
        args.state.board << x
      end
    end
    args.state.board
  end

  def make_hud args
    return unless args.state.hud.nil?
    # hud is the bottom most 
    args.state.hud = []
    (5..10).each do |n|
      args.state.hud << Control.new(n,0,Gsize,Gsize,Green)
    end
    args.state.hud
  end

  def make_create_menu args
    return if args.state.sprite_menu
    #ok, need to click on a thing, which maps to a class
    #Dir.each_child('./sprites/this') do |filename|
    # if click is 
    #iterate through list and check if mouts
    args.state.sprite_menu = []

    args.state.sprite_menu << {position:{x: 0,y: 1,w: Gsize,h: Gsize},color:Darkblue,type: :Block }
    args.state.sprite_menu << {position:{x: 0,y: 2,w: Gsize,h: Gsize}, color:Green,type: :Block}
    args.state.sprite_menu << {position:{x: 0,y: 3,w: Gsize,h: Gsize}, color:Yellow,type: :Block}
    args.state.sprite_menu << {position:{x: 0,y: 4,w: Gsize,h: Gsize}, color:Orange,type: :Block}
    args.state.sprite_menu << {position:{x: 0,y: 5,w: Gsize,h: Gsize},color: Red,type: :Block}
    args.state.sprite_menu << {position:{x: 0,y: 6,w: Gsize,h: Gsize},
                               type: :Guy,sprite: 'sprites/misc/lowrez-ship-red.png'}
    args.state.sprite_menu << {position: {x: 0,y: 7,w: Gsize,h: Gsize},
                               type: :Guy,sprite: 'sprites/misc/lowrez-ship-blue.png'}
  end
  
  def make_teams args
    return unless args.state.teams.empty?
    #args.state.teams.redteam = Team.new("Redteam")
    #args.state.teams.blueteam = Team.new("Blueteam")
    args.state.teams << Team.new("Redteam")
    args.state.teams << Team.new("Blueteam")
  end
end
