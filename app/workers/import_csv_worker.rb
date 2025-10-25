require "csv"

class ImportCsvWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(job_id)
    job = ImportJob.find(job_id)
    job.update!(status: "processing")

    begin
      # Baixar o arquivo CSV do Active Storage
      csv_file = job.csv_file.download

      # Parse do CSV
      csv = CSV.parse(csv_file, headers: true, header_converters: :symbol)

      csv.each_with_index do |row, index|
        Rails.logger.info "Processing row #{index + 1}: #{row.to_h}"

        # Limpar e validar os dados
        category_name = row[:category]&.to_s&.strip
        title = row[:title]&.to_s&.strip

        # Pular linhas vazias ou inválidas
        next if category_name.blank? || title.blank?

        # Buscar ou criar categoria
        category = Category.find_or_create_by!(name: category_name)

        # Criar o filme
        movie = job.user.movies.create!(
          title: title,
          synopsis: row[:synopsis]&.to_s&.strip,
          release_year: row[:release_year]&.to_i,
          duration: row[:duration]&.to_i,
          director: row[:director]&.to_s&.strip
        )

        # Associar a categoria ao filme
        movie.categories << category

        Rails.logger.info "Created movie: #{title} with category: #{category_name}"
      end

      job.update!(status: "completed")
      ImportMailer.notify_success(job).deliver_now

    rescue => e
      Rails.logger.error "ImportCsvWorker failed: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      job.update!(status: "failed", error_message: e.message)
    end
  end
end
