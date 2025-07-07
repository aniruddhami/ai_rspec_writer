# ai_rspec_writer

`ai_rspec_writer` is an AI-powered tool for generating **RSpec test cases** in **Ruby on Rails applications**. It supports **ChatGPT** and **Gemini AI** to create **model, controller, and service tests** automatically, improving test coverage and development efficiency.

---

## **🚀 Features**
- 📝 **Automatically generates RSpec tests** for models, controllers, and services.
- 📌 **Extracts database schema** for validation and association tests.
- 🛠 **Supports both ChatGPT and Gemini AI**.
- 🔍 **Customizable test instructions** using extra comments.
- 🏆 **Ensures high code coverage** by generating edge-case scenarios.
- 🔑 **Secure API authentication** using OpenAI & Google Gemini keys.

---

## **🛠 Installation**
### **1️⃣ Add to your Gemfile**
```ruby
group :development, :test do
  gem 'ai_rspec_writer'
  gem 'factory_bot_rails' # Generates dummy data
  gem 'rails-controller-testing' # Required for controller specs
  gem 'faker' # Fake data generation
  gem 'shoulda-matchers', '~> 5.0' # One-liner matchers for RSpec
  gem 'simplecov', require: false # Code coverage analysis
end
```

### **2️⃣ Run Bundle Install**
```sh
bundle install
```

### **3️⃣ Generate Configuration Files**
Run the generator to create the necessary configuration files:
```sh
rails generate ai_rspec_writer:install
```

**What this command does:**
- 📁 Creates `config/initializers/ai_rspec_writer.rb` with default configuration
- 📄 Generates `.env.example` file with required environment variables
- 🔧 Sets up default AI models and configuration options
- 📝 Creates sample configuration for easy customization

**Generated files:**
```
config/initializers/ai_rspec_writer.rb
.env.example
```

### **4️⃣ Set up API Keys**
Copy the example environment file and add your API keys:
```sh
cp .env.example .env
```

Edit `.env` file and add your API keys:
```
CHATGPT_API_KEY=your-openai-api-key
GEMINI_API_KEY=your-google-gemini-api-key
DEFAULT_AI=chatgpt
CHATGPT_MODEL=gpt-4
GEMINI_MODEL=gemini-2.0-flash-exp
```

Or export them in your terminal:
```sh
export CHATGPT_API_KEY="your-openai-api-key"
export GEMINI_API_KEY="your-google-gemini-api-key"
export DEFAULT_AI="chatgpt"
export CHATGPT_MODEL="gpt-4"
export GEMINI_MODEL="gemini-2.0-flash-exp"
```

**Default Settings:**
```
GEMINI_MODEL=gemini-2.0-flash-exp
CHATGPT_MODEL=gpt-4
DEFAULT_AI=chatgpt
```

---

## **📌 Usage** 
### **Command Structure**
```sh
bundle exec ai_rspec_writer -f <file_path> -t <table_names> -e "<extra_comment>" -a <ai_model>
```

### **🔹 Example Commands**
#### ✅ Generate RSpec tests using `Gemini AI`
```sh
bundle exec ai_rspec_writer -f app/controllers/obento/obento_zaikos_controller.rb,app/models/store_notification.rb,app/models/common_setting.rb -t store_notifications,common_settings -e "use devise admin and ensure 100% test coverage" -a gemini
```

#### ✅ Generate RSpec tests using `ChatGPT AI`
```sh
bundle exec ai_rspec_writer -f app/controllers/obento/obento_zaikos_controller.rb,app/models/store_notification.rb,app/models/common_setting.rb -t store_notifications,common_settings   -e "use devise admin and ensure 100% test coverage" -a chatgpt
```

#### ✅ Generate RSpec tests without -a flag
If no AI model (-a) is passed, ai_rspec_writer will default to DEFAULT_AI from .env or use ChatGPT if not explicitly set.
```sh
bundle exec ai_rspec_writer -f app/controllers/obento/obento_zaikos_controller.rb,app/models/store_notification.rb,app/models/common_setting.rb -t store_notifications,common_settings   -e "use devise admin and ensure 100% test coverage"
```

---

## **🔍 Command Options**
| **Option** | **Description** | **Example** |
|------------|----------------|-------------|
| `-f, --files` | Files to generate tests for (**comma-separated** paths). | `-f app/models/user.rb,app/controllers/users_controller.rb` |
| `-t, --table_name` | **Database tables** to extract schema info for tests. | `-t users,orders` |
| `-e, --ec` | **Extra comments** to customize test behavior. | `-e "use Devise authentication"` |
| `-a, --ai` | **AI model** to use (`chatgpt` or `gemini`). | `-a gemini` |

---

## **⚙️ Configuration**
After running the install generator, you can customize the gem's behavior by editing `config/initializers/ai_rspec_writer.rb`:

```ruby
AiRspecWriter.configure do |config|
  config.chatgpt_api_key = ENV['CHATGPT_API_KEY']
  config.gemini_api_key = ENV['GEMINI_API_KEY']
  config.default_ai = ENV['DEFAULT_AI'] || 'chatgpt'
  config.chatgpt_model = ENV['CHATGPT_MODEL'] || 'gpt-4'
  config.gemini_model = ENV['GEMINI_MODEL'] || 'gemini-2.0-flash-exp'
  
  # Optional: Customize default behavior
  config.output_directory = 'spec'
  config.include_factory_bot = true
  config.include_shoulda_matchers = true
end
```

---

## **📝 Example Output**
After running:
```sh
bundle exec ai_rspec_writer -f app/models/store_notification.rb -t store_notifications -e "use FactoryBot"
```
It generates:
```ruby
# spec/models/store_notification_spec.rb
require 'rails_helper'

RSpec.describe StoreNotification, type: :model do
  let(:store_notification) { create(:store_notification) }

  describe "Validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:message) }
  end

  describe "Associations" do
    it { should belong_to(:store) }
  end

  describe "Methods" do
    it "sends notification successfully" do
      expect(store_notification.send_notification).to be_truthy
    end
  end
end
```

---

## **⚠️ Troubleshooting**
### **❌ `ChatGPT API key is missing.`**
**Solution:** Set the API key in `.env`:
```
CHATGPT_API_KEY=your-api-key
```
Or export it:
```sh
export CHATGPT_API_KEY="your-api-key"
```

### **❌ `Gemini API key is missing.`**
**Solution:** Set the Gemini API key in `.env`:
```
GEMINI_API_KEY=your-api-key
```

### **❌ `Error: Please provide a file to generate tests for using -f`**
**Solution:** Ensure you pass the `-f` option with valid file paths:
```sh
bundle exec ai_rspec_writer -f app/models/user.rb
```

### **❌ Tests are not covering all cases**
**Solution:** Try providing additional **extra comments**:
```sh
bundle exec ai_rspec_writer -f app/models/user.rb -e "Generate edge case tests"
```

### **❌ `Initializer not found` error**
**Solution:** Make sure you ran the install generator:
```sh
rails generate ai_rspec_writer:install
```

---

## **📜 License**
This project is licensed under the **MIT License**.

---

## **👨‍💻 Contributors**
- [@aniruddhami](https://github.com/aniruddhami) 🎉
- **Open for Contributions!** Feel free to fork & improve.

---

## **✨ Future Improvements**
- 📌 **RSpec test generation improvements**
- 📌 **Support for Minitest**
- 📌 **AI model selection enhancements**
- 📌 **More detailed error handling**