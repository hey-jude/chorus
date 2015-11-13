require 'spec_helper'

describe OpenWorkfileEvent do
  context 'callbacks' do

    describe 'after_create' do
      let(:user)       { users(:owner) }
      let(:other_user) { users(:admin) }
      let(:workfile)   { Workfile.first }

      it 'should delete the old events for the user' do

        number_of_events = OpenWorkfileEvent::EVENT_LIMIT + 5
        first_event = OpenWorkfileEvent.create!(:user => user, :workfile => workfile)

        number_of_events.times do
          OpenWorkfileEvent.create!(:user => user, :workfile => workfile)
        end

        expect(
          OpenWorkfileEvent.where(:user => user).count
        ).to eq(15)

        expect(OpenWorkfileEvent.where(:id => first_event.id).to_a.count).to eq(0)
      end

      it 'should not delete other user events' do
        5.times do
          OpenWorkfileEvent.create!(:user => other_user, :workfile => workfile)
        end
        other_user_count = OpenWorkfileEvent.where(:user => other_user).count

        OpenWorkfileEvent.create!(:user => user, :workfile => workfile)
        expect(OpenWorkfileEvent.where(:user => other_user).count).to eq(other_user_count)
      end
    end
  end

end
