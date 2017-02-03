mail_config = APP_CONFIG.fetch(:mail_config, {})
Beermapper::Application.config.action_mailer.smtp_settings = mail_config
