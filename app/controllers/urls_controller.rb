class UrlsController < ApplicationController
	
	def create
		# Returns 400 if url param is not passed
		params.require(:url)

		short_code = params[:code]

		if short_code.present?
			if Url.find_by(code: short_code)
				# Returns 409 Conflict if code is already found in database
				render json: { errors: 'Desired short code is already in use'}, status: 409 and return
			end
		else
			# Generate unique 6 digit alphanumeric short_code
			short_code = SecureRandom.alphanumeric(6)
			short_code = SecureRandom.alphanumeric(6) while Url.find_by(code: short_code)
		end
		
		# Create Url record in db
		url = Url.create(url: params[:url], code: short_code)

		if url.valid?
			render json: { code: url.code }, status: 201
		else
			render json: { errors: url.errors.full_messages, code: short_code }, status: 422
		end
	end


	def show
		url = Url.find_by(code: params.require(:code))
		if url
			url.increment(:hits)
			url.update!(updated_at: Time.current)

			render json: { url: url.url }
		else
			render json: { errors: 'Code not found' }, status: 404
		end
	end

	def stats
		url = Url.find_by(code: params.require(:code))
		if url
			render json: { 
				created_at: url.created_at.to_formatted_s(:iso8601),
				last_usage: url.updated_at.to_formatted_s(:iso8601),
				usage_count: url.hits
			}
		else
			render json: { errors: 'Code not found' }, status: 404
		end
	end
end
