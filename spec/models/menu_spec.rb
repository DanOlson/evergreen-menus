require 'spec_helper'

describe Menu do
  let(:establishment) { create :establishment }
  let!(:menu) do
    Menu.create!({
      name: 'Beers',
      establishment: establishment
    })
  end
  let(:taps) do
    List.create!({
      name: 'Taps',
      establishment: establishment
    })
  end
  let(:bottles) do
    List.create!({
      name: 'Bottles',
      establishment: establishment
    })
  end
  let(:specials) do
    List.create!({
      name: 'Specials',
      establishment: establishment
    })
  end

  describe '#add_list' do
    it 'adds lists to the menu' do
      menu.add_list taps
      menu.add_list bottles

      expect(menu.lists.size).to eq 2
    end

    it 'adds lists in order' do
      menu.add_list bottles, position: 1
      menu.add_list specials, position: 2
      menu.add_list taps, position: 0

      expect(menu.lists[0]).to eq taps
      expect(menu.lists[1]).to eq bottles
      expect(menu.lists[2]).to eq specials
    end
  end

  describe 'deleting menus' do
    context 'with lists' do
      before do
        menu.add_list bottles
        menu.add_list specials
        menu.add_list taps
      end

      it 'leaves no menu_lists behind' do
        menu.destroy
        menu_list_count = MenuList.where(menu_id: menu.id).count
        expect(menu_list_count).to eq 0
      end
    end
  end

  describe '#show_logo?' do
    let(:menu) { build :menu, establishment: establishment, show_logo: attr_value }
    subject { menu.show_logo? }

    context 'when the "show_logo" attribute is true' do
      let(:attr_value) { true }

      context 'and the establishment has a logo' do
        let(:establishment) { create :establishment, :with_logo }

        it { is_expected.to eq true }
      end

      context 'and the establishment does not have a logo' do
        let(:establishment) { create :establishment }

        it { is_expected.to eq false }
      end
    end

    context 'when the "show_logo" attribute is false' do
      let(:attr_value) { false }

      context 'and the establishment has a logo' do
        let(:establishment) { create :establishment, :with_logo }

        it { is_expected.to eq false }
      end

      context 'and the establishment does not have a logo' do
        let(:establishment) { create :establishment }

        it { is_expected.to eq false }
      end
    end
  end
end
