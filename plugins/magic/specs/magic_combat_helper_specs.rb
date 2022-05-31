# # module AresMUSH
# #     module Magic
#       describe Combatant do
#         before do
#           @combatant = double
#           @char = double
#           allow(@combatant).to receive(:log)
#           allow(@combatant).to receive(:name) { "Mage" }
#           allow(@combatant).to receive(:character) { @char }
#           stub_translate_for_testing
#         end
        
#         describe :roll_combat_spell_success do
#             before do
#               allow(@combatant).to receive(:roll_ability) { 2 }
#               allow(@combatant).to receive(:weapon) { "Knife" }
#               allow(@combatant).to receive(:luck)
#               @target = double
#               allow(@target).to receive(:mount_type) { nil }
#               allow(@combatant).to receive(:mount_type) { nil }
#             end

#             it "should roll the school skill if the caster is a member of the school group" do
#               expect @combat.to recieve(:)