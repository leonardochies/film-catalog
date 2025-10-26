require 'rails_helper'

RSpec.describe "ImportJobs", type: :request do
  let(:user) { create(:user) }

  describe "GET /import_jobs" do
    context "when user is not authenticated" do
      it "redirects to login page" do
        get import_jobs_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is authenticated" do
      before { sign_in user }

      it "returns http success" do
        get import_jobs_path
        expect(response).to have_http_status(:success)
      end

      it "displays user's import jobs" do
        create(:import_job, user: user)
        get import_jobs_path
        expect(response.body).to include("Import Jobs")
      end
    end
  end

  describe "GET /import_jobs/new" do
    context "when user is not authenticated" do
      it "redirects to login page" do
        get new_import_job_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is authenticated" do
      before { sign_in user }

      it "returns http success" do
        get new_import_job_path
        expect(response).to have_http_status(:success)
      end

      it "displays the import form" do
        get new_import_job_path
        expect(response.body).to include("csv_file")
      end
    end
  end

  describe "POST /import_jobs" do
    context "when user is not authenticated" do
      it "redirects to login page" do
        post import_jobs_path, params: { import_job: { csv_file: nil } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when user is authenticated" do
      before { sign_in user }

      context "with valid CSV file" do
        let(:csv_file) do
          fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'movies.csv'), 'text/csv')
        end

        it "creates a new import job" do
          expect {
            post import_jobs_path, params: { import_job: { csv_file: csv_file } }
          }.to change(ImportJob, :count).by(1)
        end

        it "redirects to import jobs index" do
          post import_jobs_path, params: { import_job: { csv_file: csv_file } }
          expect(response).to redirect_to(import_jobs_path)
        end

        it "displays success message" do
          post import_jobs_path, params: { import_job: { csv_file: csv_file } }
          follow_redirect!
          expect(response.body).to include("Importação iniciada!")
        end
      end

      context "without CSV file" do
        it "does not create import job" do
          expect {
            post import_jobs_path, params: { import_job: { csv_file: nil } }
          }.not_to change(ImportJob, :count)
        end

        it "renders new template with errors" do
          post import_jobs_path, params: { import_job: { csv_file: nil } }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
