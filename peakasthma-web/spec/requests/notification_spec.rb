describe 'Notifications' do
  let!(:patient_params) { Fabricate.attributes_for(:patient) }
  let!(:patient_user) { Fabricate :user, created_at: 1.day.ago, patient_attributes: patient_params.merge({ created_at: 1.day.ago }) }
  let!(:admin) { Fabricate :user, role: User.roles[:admin] }
  let!(:unsent_notifications) { Fabricate.times 6, :notification, author: admin }
  let!(:sent_notifications) { Fabricate.times 6, :notification, sent: true, author: admin, patients: [patient_user.patient] }

  describe 'Limited to admin access' do
    describe 'Non-admin user' do
      it 'should not display the page, should redirect the user' do
        confirm_and_login patient_user

        visit notifications_path
        expect(page).to_not have_selector('.notification-table')
        expect(page.current_path).to_not eq notifications_path

        visit edit_notification_path (unsent_notifications.first)
        expect(page).to_not have_selector('.notification-form')
        expect(page.current_path).to_not eq new_medication_path
      end
    end
  end

  describe 'admin access' do
    before do
      confirm_and_login admin
      visit notifications_path
    end

    it 'should display the notification index table, and list the paginated notifications' do
      expect(page).to have_selector('.notification-table')
      expect(page).to have_selector('.notification-table tbody tr', count: 10)
      unsent_notifications.each do |notification|
        expect(page).to have_content notification.message
      end
    end

    it 'properly calculates the values for notifications' do
      sent_notifications.first(3).each do |notification|
        Fabricate :read_notification_record, patient: patient_user.patient, notification: notification
      end
      visit notifications_path

      stats = page.all('.mobile-asthma-statistic__percentage')

      expect(stats[0].text).to match('50%');
      expect(stats[1].text).to match('6');
      expect(stats[2].text).to match('3');
      expect(stats[3].text).to match('25%');
    end

    it 'clicking on a notification\'s edit button will take the user to the edit screen' do
      click_link("#{unsent_notifications.first.id}_edit")
      expect(page.current_path).to eq edit_notification_path(unsent_notifications.first)

      fill_in('notification_message', with: 'This is an updated message.')
      find('input[type=submit]').click

      expect(page.current_path).to eq notifications_path
      expect(page).to have_content('This is an updated message.')
    end

    it 'clicking on a notification\'s delete button will delete the notification' do
      expect {
        click_link("#{unsent_notifications.first.id}_delete")
      }.to change{Notification.all.count}.by(-1)
      expect(page.current_path).to eq notifications_path
    end

    it 'lets the user create a notification on the index page', js: true do
      fill_in('notification_message', with: 'This is a message created in the request spec.')
      fill_in('notification_datetime_send_at', with: DateTime.current + 1.minutes)
      find('#new_notification input[type=submit]').click

      expect(page).to have_content('This is a message created in the request spec.')
    end

    it 'will not let the user edit an already sent message' do
      visit edit_notification_path(sent_notifications.first)
      expect(page).to_not eq edit_notification_path(sent_notifications.first)
      expect(page).to have_content(I18n.t 'notification.errors.already_sent')
    end
  end

end