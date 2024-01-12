RSpec.describe PeakFlow do
  include ActiveJob::TestHelper

  let!(:green_symptom) { Fabricate :symptom, level: :green }
  let!(:yellow_symptom) { Fabricate :symptom, level: :yellow }
  let!(:red_symptom) { Fabricate :symptom, level: :red }

  let!(:user) { Fabricate :user }
  let!(:patient) { Fabricate :patient, user: user }

  let!(:peak_flow) { Fabricate :peak_flow, patient: patient }

  let!(:green_report) { Fabricate :peak_flow, symptoms: [], patient: patient, score: nil }
  let!(:yellow_report) { Fabricate :peak_flow, symptoms: [yellow_symptom], patient: patient, score: nil }
  let!(:red_report) { Fabricate :peak_flow, symptoms: [red_symptom], patient: patient, score: nil }

  it { is_expected.to belong_to(:patient) }
  it { should have_and_belong_to_many(:symptoms) }

  it 'enqueues an activity model creation job when created' do
    assert_enqueued_jobs 1, only: ActivityHistoryJob do
      Fabricate :peak_flow, patient: patient
    end
  end

  describe '#level' do
    it 'should return green when the peak flow score is in the green zone or higher' do
      peak_flow.score = patient.yellow_zone_maximum
      expect(peak_flow.level).to eq :yellow

      peak_flow.score = patient.yellow_zone_maximum + 1
      expect(peak_flow.level).to eq :green
    end

    it 'should return yellow when the peak flow score is in the yellow zone' do
      peak_flow.score = patient.yellow_zone_maximum - 1
      expect(peak_flow.level).to eq :yellow

      peak_flow.score = patient.yellow_zone_minimum
      expect(peak_flow.level).to eq :yellow

      peak_flow.score = patient.yellow_zone_minimum + 1
      expect(peak_flow.level).to eq :yellow
    end

    it 'should return red when the peak flow score is below the yellow zone cutoff' do
      peak_flow.score = patient.yellow_zone_minimum - 1
      expect(peak_flow.level).to eq :red

      peak_flow.score = 0
      expect(peak_flow.level).to eq :red
    end

    it 'returns green when there is no score or symptoms' do
      expect(green_report.level).to eq :green
    end

    it 'returns yellow when a SymptomReport has yellow level symptoms' do
      expect(yellow_report.level).to eq :yellow
    end

    it 'returns red when a SymptomReport has red level symptoms' do
      expect(red_report.level).to eq :red
    end
  end

  describe '#check_in_with_patient' do
    before do
      Fabricate :peak_flow, patient: patient, score: nil, symptoms: []
    end

    it 'does not queue a message when the user enters a green zone peak flow' do
      assert_no_enqueued_jobs only: PeakFlowNotificationJob do
        Fabricate :peak_flow, patient: patient, score: nil, symptoms: []
      end
    end

    it 'queues a message when the user enters a yellow zone peak flow' do
      assert_enqueued_jobs 1, only: PeakFlowNotificationJob do
        Fabricate :peak_flow, symptoms: [yellow_symptom], patient: patient, score: nil
      end
    end

    it 'fires off a message right away if this is the second yellow reading in a row' do
      assert_enqueued_jobs 1, only: PeakFlowNotificationJob do
        Fabricate :peak_flow, symptoms: [yellow_symptom], patient: patient, score: nil
      end
    end

    it 'queues a message when the user enters a red zone peak flow' do
      assert_enqueued_jobs 1, only: PeakFlowNotificationJob do
        Fabricate :peak_flow, symptoms: [red_symptom], patient: patient, score: nil
      end
    end

    it 'fires off a message right away if this is the second red reading in a row' do
      assert_enqueued_jobs 1, only: PeakFlowNotificationJob do
        Fabricate :peak_flow, symptoms: [red_symptom], patient: patient, score: nil
      end
    end
  end
end
