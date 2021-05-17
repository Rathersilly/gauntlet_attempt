# These must be forward declared for reasons

require '/app/init/tools.rb'
require '/app/init/init_anims.rb'

require '/app/components/components.rb'
require '/app/components/anim.rb'
require '/app/components/anim_group.rb'
require '/app/components/behavior.rb'
require '/app/component_registry.rb'

require '/app/systems/system.rb'
require '/app/systems/animation.rb'
require '/app/systems/render_static_solids.rb'
require '/app/systems/render_solids.rb'
require '/app/systems/render_sprites.rb'
require '/app/systems/behavior.rb'
require '/app/systems/behavior_mods.rb'
require '/app/systems/cleanup.rb'

require '/app/factories/factory.rb'
require '/app/factories/block_factory.rb'
require '/app/factories/mage_factory.rb'
# require '/app/factories/archmage_factory.rb'
require '/app/factories/steelclad_factory.rb'
require '/app/factories/adept_factory.rb'
require '/app/factories/spell_factory.rb'

require '/app/init/init_world.rb'
require '/app/world.rb'

require '/app/tick.rb'
