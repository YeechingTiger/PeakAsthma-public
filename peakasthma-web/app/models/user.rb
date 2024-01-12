class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable
  # :confirmable

  has_many :prescriptions
  has_many :clincard_balance_requests
  has_one :patient, dependent: :destroy
  has_one :guardian, dependent: :destroy
  has_one :control_patient, dependent: :destroy
  accepts_nested_attributes_for :patient
  accepts_nested_attributes_for :control_patient

  ROLES = [:patient, :admin, :guardian, :control_patient].freeze
  enum role: ROLES

  validates :username, presence: true, uniqueness: { case_sensitive: false }, format: { with: /^[a-zA-Z0-9_\.]*$/, multiline: true }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :role, presence: true
  validates :patient, presence: true, if: :patient?
  validates :control_patient, presence: true, if: :control_patient?
  
  scope :admins, -> { where(role: 'admin') }

  def first_mobile_login?
    !used_mobile_app
  end

  def first_initial
    first_name[0]
  end

  def last_name_first_initial
    "#{last_name}, #{first_initial}."
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  # Devise overrides
  def password_required?
    false
    # super if confirmed?
  end

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end
end
