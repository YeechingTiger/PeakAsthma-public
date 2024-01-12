require 'spec_helper'
describe 'Prescriptions' do
  let!(:patient_user) { Fabricate :user }
  let!(:admin) { Fabricate :user, role: User.roles[:admin] }
  let!(:medications) { Fabricate.times 10, :medication }
  let!(:prescriptions) { Fabricate.times 10, :prescription, patient: patient_user.patient }

  describe 'Limited to admin access' do
    describe 'Non-admin user' do
      it 'should not display the page, should redirect the user' do
        confirm_and_login patient_user

        visit new_patient_prescription_path(patient_user.patient)
        expect(page.current_path).to_not eq new_patient_prescription_path(patient_user.patient)

        visit edit_patient_prescription_path(patient_user.patient, prescriptions.first)
        expect(page.current_path).to_not eq edit_patient_prescription_path(patient_user.patient, prescriptions.first)
      end
    end
  end

  describe 'admin access' do
    before do
      confirm_and_login admin
      visit patient_path(patient_user.patient)
    end

    describe '#new, #create', js: true do
      it 'navigates to the new item view, accepts params, and creates a new medication' do
        click_link(I18n.t('prescription.views.buttons.create'))
        expect(page.current_path).to eq new_patient_prescription_path(patient_user.patient)

        expect(page).to_not have_field('prescription_quantity')
        expect(page).to_not have_field('prescription_unit')
        expect(page).to_not have_field('prescription_frequency')

        medication_selected = medications.first
        expect { fill_out_form(medication_selected) }.to change{Prescription.count}.by(1)

        expect(Prescription.last.medication).to eq medication_selected
        expect(Prescription.last.quantity).to eq 10
      end
    end

    describe '#edit, #update', js: true do
      it 'navigates to the new item view, accepts params, and creates a new medication' do
        prescription_to_edit = prescriptions.first
        click_link("edit-prescription-#{prescriptions.first.id}")
        expect(page.current_path).to eq edit_patient_prescription_path(patient_user.patient, prescription_to_edit)

        expect(page).to have_field('prescription_quantity')
        expect(page).to have_field('prescription_unit')
        expect(page).to have_field('prescription_frequency')

        medication_selected = medications.last
        expect { fill_out_form(medication_selected) }.to change{Prescription.count}.by(0)
      end
    end

    describe '#delete' do
      it 'deletes the model when clicking the delete icon' do
        expect{ click_link("delete-prescription-#{prescriptions.first.id}") }.to change{Prescription.count}.by(-1)
        expect(page.current_path).to eq patient_path(patient_user.patient)
      end
    end
  end

  def fill_out_form(medication)
    formulation_type = medication.formulation.to_sym;
    frequency_type = formulation_type == :injection ? :injections : :medications

    select(medication.name, from: 'prescription_medication_id')
    wait_for_ajax

    expect(page).to have_field('prescription_quantity')
    expect(page).to have_field('prescription_unit')
    expect(page).to have_field('prescription_frequency')

    fill_in('prescription_quantity', with: 10 )
    select(I18n.t("prescription.model.units.#{Prescription::UNITS[formulation_type].first}"), from: 'prescription_unit')
    select(I18n.t("prescription.model.frequencies.#{Prescription::FREQUENCIES[frequency_type].first}"), from: 'prescription_frequency')
    find('input[type=submit]').click
    wait_for_ajax
  end

end