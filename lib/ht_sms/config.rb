module HtSms

    Setting = defined?(Setting) ? Settings : {}

    class << self

        def test_env(test=nil)
            if test.nil?
                @test ||= defined?(Rails) ? Rails.env.test? : true
            else
                @test = !!test
            end
        end

        def config
            if Emitter == DuanXinBao
                dxb = defined?(Setting.duan_xin_bao) ? Setting.duan_xin_bao : nil
                @dxb_config ||= {
                    account: dxb && dxb.account,
                    password: dxb && dxb.password,
                    url: dxb && dxb.url
                }
            end
        end

    end

end
