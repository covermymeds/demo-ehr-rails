require 'rails_helper'

RSpec.describe PaRequest, type: :model do
  let(:request_params) do
    {
      cmm_link: 'https://blah',
      cmm_outcome: 'Unknown',
      cmm_workflow_status: 'New',
      cmm_token: 'kdksksdkfadkjadf',
      cmm_id: '123ABC',
      form_id: 'this_is_a_form',
      prescriber_id: 1,
    }
  end

  context "validations" do
    context "with valid arguments" do
      it 'is valid' do
        pa_request = PaRequest.new(request_params)
        expect(pa_request).to be_valid
      end
    end
  end

  context "ncpdp message processing" do
    context "PAInitResponse" do
      fixtures :pa_requests

      let(:pa_request) { pa_requests('pa_request_one') }
      let(:xml)    { fixture("PAInitiationResponse.xml").read }
      let(:doc)    { NCPDP::InitiationResponse.parse xml }

      context "when open" do
        it "records the deadline for reply" do
          pa_request.process_message(doc)
          expect(pa_request.datetime_for_reply).to eq(doc.response_status.Open.DeadlineForReply.DateTime.to_datetime)
        end

        it "records the PANote if supplied" do
          pa_request.process_message(doc)
          expect(pa_request.note).to eq(doc.note)
        end

        it "adds the questions to the PA" do
          pa_request.process_message(doc)
          expect(pa_request.question_sets.count).to eq(1)
          expect(pa_request.question_sets.first.questions.count).to eq(doc.question_set.questions.count)
        end

        it "adds choices to the database for choice questions" do
          pa_request.process_message(doc)
          select_question = pa_request.question_sets.first.questions.where(question_type:'select').first
          expect(select_question.choices.count).to eq(5) 
          expect(select_question.select_multiple).to eq("Y")
        end
      end

      context "when closed" do
        context "duplicate/approved" do
          let(:xml)    { fixture("PAInitiationResponseApproved.xml").read }

          it  "marks the PA as approved" do
            pa_request.process_message(doc)
            expect(pa_request.cmm_workflow_status).to eq("QuestionResponse")
            expect(pa_request.cmm_outcome).to eq("Favorable")
          end

          it "records any note from the plan" do
            pa_request.process_message(doc)
            expect(pa_request.note).to eq(doc.note)
          end
        end  

        context "when approval information is sent" do
          let(:xml) {fixture("PAInitiationResponseApprovedInfo.xml").read }

          pending "records the effective date"
          # it "records the effective date" do
          #   pa_request.process_message(doc)
          #   expect(pa_request.effective_datetime).to eq(doc.response_status.Closed.AuthorizationPeriod.EffectiveDate.DateTime.to_datetime)
          # end

          pending "records the expiration date"
          # it "records the expiration date" do
          #   pa_request.process_message(doc)
          #   expect(pa_request.expiration_datetime).to eq(doc.response_status.Closed.AuthorizationPeriod.ExpirationDate.DateTime.to_datetime)
          # end
        end

        context "when authorization detail is sent" do
          pending "records the authorization detail"
          pending "records the note sent from the plan"
        end

        context "PA not needed" do
          let(:xml)    { fixture("PAInitiationResponseClosed.xml").read }

          it "marks the PA as not needed" do
            pa_request.process_message(doc)
            expect(pa_request.note).to eq(doc.note)
            expect(pa_request.cmm_workflow_status).to eq("QuestionResponse")
            expect(pa_request.cmm_outcome).to eq("PA not required")
          end
        end

      end
    end

    context "PAResponse" do
      fixtures :pa_requests

      let(:pa_request) { pa_requests('pa_request_one') }
      let(:doc)    { NCPDP::Response.parse xml }


      context "when approved" do
        let(:xml)    { fixture("PAResponse.xml").read }

        it "records the note from the plan" do
          pa_request.process_message(doc)
          expect(pa_request.note).to eq(doc.pa_note)
        end

        it "marks the PA as approved" do
          pa_request.process_message(doc)
          expect(pa_request.cmm_outcome).to eq("Favorable")
          expect(pa_request.cmm_workflow_status).to eq("PAResponse")
        end

        context "when approval information is sent" do
          pending "records the effective date"
          # it "records the effective date" do
          #   pa_request.process_message(doc)
          #   expect(pa_request.effective_datetime).to eq(doc.response_status.Closed.AuthorizationPeriod.EffectiveDate.DateTime.to_datetime)
          # end

          pending "records the expiration date"
          # it "records the expiration date" do
          #   pa_request.process_message(doc)
          #   expect(pa_request.expiration_datetime).to eq(doc.response_status.Closed.AuthorizationPeriod.ExpirationDate.DateTime.to_datetime)
          # end

        end

      end

      context "when denied" do
        let(:xml) {fixture("PAResponseDenied.xml").read}

        it "records the note from the plan" do
          pa_request.process_message(doc)
          expect(pa_request.note).to eq(doc.pa_note)
        end

        it "marks the PA as denied" do
          binding.pry
          pa_request.process_message(doc)
          expect(pa_request.cmm_workflow_status).to eq("PAResponse")
          expect(pa_request.cmm_outcome).to eq("Unfavorable")
        end

        it "records if appeal is supported" do
          pa_request.process_message(doc)
          expect(pa_request.appeal_supported).to eq("N")
        end
      end

      context "when open" do
        let(:xml) {fixture("PAResponseWithMoreInfoRequired.xml").read}

        it "records the note from the plan" do
          pa_request.process_message(doc)
          expect(pa_request.note).to eq(doc.pa_note)
        end

        it "marks the PA as pending" do
          pa_request.process_message(doc)
          expect(pa_request.cmm_outcome).to eq("Pending")
        end

        it "records the other reason code" do
          pa_request.process_message(doc)
          expect(pa_request.still_open_reason).to eq(doc.response_status.Open.Reason.OtherReason)
        end

        it "records the deadline for reply" do
          pa_request.process_message(doc)
          expect(pa_request.datetime_for_reply).to eq(doc.response_status.Open.Reason.MoreInformationRequired.DeadlineForReply.DateTime.to_datetime)
        end

        it "adds the questions to the PA" do
          pa_request.process_message(doc)
          expect(pa_request.question_sets.count).to eq(1)
          expect(pa_request.question_sets.first.questions.count).to eq(doc.response_status.Open.Reason.MoreInformationRequired.Questions.count)
        end
      end

      context "when closed" do
        let(:xml) {fixture("PAResponseClosed.xml").read}

        it "records the note from the plan" do
          pa_request.process_message(doc)
          expect(pa_request.note).to eq(doc.pa_note)
        end

        it "updates the closed reason code appropriately" do
          pa_request.process_message(doc)
          expect(pa_request.closed_reason_code).to eq(doc.response_status.Closed.ClosedReasonCode)
        end

        it "records the effective date" do
          pa_request.process_message(doc)
          expect(pa_request.effective_datetime).to eq(doc.response_status.Closed.AuthorizationPeriod.EffectiveDate.DateTime.to_datetime)
        end

        it "records the expiration date" do
          pa_request.process_message(doc)
          expect(pa_request.expiration_datetime).to eq(doc.response_status.Closed.AuthorizationPeriod.ExpirationDate.DateTime.to_datetime)
        end
      end

    end

    context "PAAppealResponse" do
      context "when approved" do
        pending "marks the PA as approved"
        pending "records any note from the plan"
        context "when approval information is sent" do
          pending "records the effective date"
          pending "records the expiration date"
        end
        context "when authorization detail is sent" do
          pending "records the authorization detail"
          pending "records the note sent from the plan"
        end
      end

      context "when denied" do
        pending "records the note if sent from the plan"
        pending "marks the PA as denied"
        pending "records if appeal is supported"
      end

      context "when open" do
        context "when More Information Required" do
          pending "records the deadline for reply"
          pending "adds the questions to the PA"
        end
        pending "records the other reason code"
      end
      
      context "when closed" do
        pending "updates the closed reason code appropriately"
        pending "records the note from the payer"
        pending "records the effective date"
        pending "records the expiration date"
      end
    end

    context "PACancelResponse" do
      fixtures :pa_requests

      let(:pa_request) { pa_requests('pa_request_one') }
      let(:xml)    { fixture("PACancelResponse.xml").read }
      let(:doc)    { NCPDP::CancelResponse.parse xml }

      context "when approved" do
        it "marks the pa as cancelled" do
          pa_request.process_message(doc)
          expect(pa_request.cmm_outcome).to eq("Cancelled")
        end

        it "updates the 'note'" do
          pa_request.process_message(doc)
          expect(pa_request.note).to eq(doc.note)
        end
      end

      context "when denied" do
        let(:xml)    { fixture("PACancelResponseDenied.xml").read }

        it "marks the pa as denied" do
          current_outcome = pa_request.cmm_outcome
          pa_request.process_message(doc)
          expect(pa_request.cmm_outcome).to eq(current_outcome)
        end

        it "updates the reason for denial" do
          pa_request.process_message(doc)
          expect(pa_request.cancel_denial_reason).to eq(doc.response_status.Denied.ReasonCode)
        end

        it "updates the 'note'" do
          pa_request.process_message(doc)
          expect(pa_request.note).to eq(doc.note)
        end
      end
    end
  end


end
