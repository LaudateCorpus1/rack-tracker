class Salesforce < Rack::Tracker::Handler

  self.position = :body

  def domain
    options[:domain]
  end

  class Track < OpenStruct

    def tracker
      @tracker ||= JSON.parse(cookies.fetch(:sfmc, "{}"))
    end

    def convert?
      tracker.any?
    end

    def delete(domain)
      cookies.delete(:sfmc, :domain => domain)
    end

    def tags
      output = <<-XML
        <system>
          <system_name>tracking</system_name>
          <action>conversion</action>
          <member_id>#{tracker["mid"]}</member_id>
          <job_id>#{tracker["j"]}</job_id>
          <email></email>
          <sub_id>#{tracker["sfmc_sub"]}</sub_id>
          <list>#{tracker["l"]}</list>
          <original_link_id>#{tracker["u"]}</original_link_id>
          <BatchID>#{tracker["jb"]}</BatchID>
          <conversion_link_id>8675309</conversion_link_id>
          <link_alias>Completed</link_alias>
          <display_order>2</display_order>
          <data_set></data_set>
        </system>
      XML

      output.strip.gsub(/(>\s+<)/, "><")
    end

  end

end
