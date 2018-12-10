class AuditActivity::Correspondence::AddPhoneCall < AuditActivity::Correspondence::Base
  include ActivityAttachable
  with_attachments attachment: "attachment"

  def self.from(correspondence, investigation)
    activity = super(correspondence, investigation, self.build_body(correspondence))
    activity.attach_blob(correspondence.transcript.blob, :attachment) if correspondence.transcript.attached?
  end

  def self.build_body correspondence
    output = ""
    output += self.build_correspondent_details correspondence
    output += "Date: **#{correspondence.correspondence_date.strftime('%d/%m/%Y')}**<br>" if correspondence.correspondence_date.present?
    output += self.build_file_body correspondence
    output += "<br>#{correspondence.details}"
    output
  end

  def self.build_correspondent_details correspondence
    return "" unless correspondence.correspondent_name || correspondence.phone_number

    output = "Call with: "
    output += "**#{correspondence.correspondent_name}** " if correspondence.correspondent_name.present?
    output += self.build_phone_number correspondence if correspondence.phone_number.present?
    output
  end

  def self.build_phone_number correspondence
    output = ""
    output += '(' if correspondence.correspondent_name.present?
    output += correspondence.phone_number
    output += ')' if correspondence.correspondent_name.present?
    output + "<br>"
  end

  def self.build_file_body correspondence
    file = correspondence.transcript
    file.attached? ? "Attached: #{file.escaped_filename}<br>" : ""
  end

  def subtitle_slug
    "Phone call"
  end
end
