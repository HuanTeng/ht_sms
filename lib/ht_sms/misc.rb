module HtSms

    class << self
        def send_sms_proxy(phone, message)
            phones, single = plural_phone(phone)
            result = { 'count' => phones.length }

            valid_phones, ivalid_phones = filter_phone_number(phones)
            ivalid_phones.each {|p| result["#{p}"] = 'ivalid phone number'}

            result.merge!(emit_sms(valid_phones, message))
            result = result["#{phones[0]}"] if single
            yield(result) if block_given?
            nil
        end

        def emit_sms(phones, message)
            if defined?(Emitter.send_multi_sms)
                result = Emitter.send_multi_sms(phones, message, HtSms.test_env)
            elsif defined?(Emitter.send_single_sms)
                result = {}
                phones.each do |phone|
                    err = Emitter.send_single_sms(phone, message, HtSms.test_env)
                    result["#{phone}"] = err
                end
            else
                raise 'no send sms method'
            end
            result
        end

        def plural_phone(phones)
            single = phones.class != Array ? true : false
            phones = [phones] if single
            return phones, single
        end

        def filter_phone_number(phones)
            valid_phones = []
            ivalid_phones = []

            phones.each do |phone|
                if validate_phone_number(phone)
                    valid_phones << phone
                else
                    ivalid_phones << phone
                end
            end
            return valid_phones, ivalid_phones
        end

        def validate_phone_number(phone_number)
            n = phone_number.to_s
            !!(n.length == 11 && /^1\d+$/.match(n))
        end

    end

end
