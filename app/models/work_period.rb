class WorkPeriod < ApplicationRecord
  belongs_to :task
  has_many_attached :files

  ALLOWED_FILE_TYPES = %w[application/pdf image/png image/jpeg image/gif image/webp image/heic].freeze
  MAX_FILE_SIZE = 25.megabytes
  validate :files_are_pdf_or_image

  scope :time_desc, -> { order(end_time: :desc) }
  scope :billable, -> { where(billable: 1) }
  scope :recent, -> { limit(200) }
  # for use in current week's time summary
  # beginning_of_week defaults to Monday, so subtracting one day from result
  scope :weekly,  lambda { where ("work_periods.end_time > ?"), (DateTime.now.beginning_of_week - 1.day) }
  scope :current_job, -> { where("start_time = end_time").limit(1) }

  private

  def files_are_pdf_or_image
    files.each do |file|
      unless ALLOWED_FILE_TYPES.include?(file.content_type)
        errors.add(:files, "#{file.filename} must be a PDF or image (png, jpg, gif, webp, heic)")
      end
      if file.byte_size > MAX_FILE_SIZE
        errors.add(:files, "#{file.filename} is larger than #{MAX_FILE_SIZE / 1.megabyte} MB")
      end
    end
  end
end
