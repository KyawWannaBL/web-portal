import React, { useState } from 'react';
import { useLanguageContext } from "@/lib/LanguageContext";
import { 
  Building2, 
  User, 
  Phone, 
  Mail, 
  MapPin, 
  FileText, 
  CreditCard,
  CheckCircle,
  ArrowRight,
  Shield,
  Truck,
  Clock
} from 'lucide-react';
import { IMAGES } from '@/assets/images';

export default function MerchantRegistration() {
  const { t } = useLanguageContext();
  const [currentStep, setCurrentStep] = useState(1);
  const [formData, setFormData] = useState({
    // Business Information
    businessName: '',
    businessType: '',
    businessLicense: '',
    taxId: '',
    
    // Contact Information
    contactPerson: '',
    position: '',
    phone: '',
    email: '',
    
    // Address Information
    address: '',
    township: '',
    city: '',
    postalCode: '',
    
    // Business Details
    businessCategory: '',
    monthlyVolume: '',
    averagePackageWeight: '',
    specialRequirements: '',
    
    // Agreement
    termsAccepted: false,
    dataProcessingAccepted: false
  });

  const handleInputChange = (field: string, value: string | boolean) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  const nextStep = () => {
    if (currentStep < 4) {
      setCurrentStep(currentStep + 1);
    }
  };

  const prevStep = () => {
    if (currentStep > 1) {
      setCurrentStep(currentStep - 1);
    }
  };

  const handleSubmit = () => {
    // Handle form submission
    console.log('Form submitted:', formData);
    alert('Registration submitted successfully! We will contact you within 24 hours.');
  };

  const businessTypes = [
    'Sole Proprietorship / တစ်ဦးတည်း လုပ်ငန်း',
    'Partnership / ပူးပေါင်း လုပ်ငန်း',
    'Private Limited Company / ပုဂ္ဂလိက ကုမ္ပဏီ',
    'Public Limited Company / အများပြည်သူ ကုမ္ပဏီ',
    'Other / အခြား'
  ];

  const businessCategories = [
    'E-commerce / အွန်လိုင်း ရောင်းချမှု',
    'Retail / လက်လီ ရောင်းချမှု',
    'Wholesale / လက်ကား ရောင်းချမှု',
    'Manufacturing / ထုတ်လုပ်မှု',
    'Food & Beverage / အစားအသောက်',
    'Fashion & Apparel / ဖက်ရှင် နှင့် အဝတ်အစား',
    'Electronics / အီလက်ထရွန်နစ်',
    'Books & Media / စာအုပ် နှင့် မီဒီယာ',
    'Health & Beauty / ကျန်းမာရေး နှင့် အလှကုန်',
    'Other / အခြား'
  ];

  const monthlyVolumeOptions = [
    '1-50 packages / ပက်ကေ့ခ် ၁-၅၀',
    '51-200 packages / ပက်ကေ့ခ် ၅၁-၂၀၀',
    '201-500 packages / ပက်ကေ့ခ် ၂၀၁-၅၀၀',
    '500+ packages / ပက်ကေ့ခ် ၅၀၀+',
    'Seasonal / ရာသီအလိုက်'
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-navy-50 via-white to-gold-50">
      {/* Header */}
      <div className="header-gradient text-white py-4">
        <div className="container mx-auto px-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <img 
                src={IMAGES.BRITIUM_LOGO_55 || "/images/britium-logo.png"}
                alt="Britium Express" 
                className="w-10 h-10 rounded-lg bg-white/10 p-1"
              />
              <span className="nav-brand">Britium Express</span>
            </div>
            <div className="hidden md:flex items-center gap-6 text-sm">
              <div className="flex items-center gap-2">
                <Phone className="w-4 h-4" />
                <span>+95-9-897447744</span>
              </div>
              <div className="flex items-center gap-2">
                <Mail className="w-4 h-4" />
                <span>info@britiumexpress.com</span>
              </div>
              <span>Mon-Sat: 9:00am - 5:30pm</span>
            </div>
          </div>
        </div>
      </div>

      {/* Navigation */}
      <nav className="bg-white/95 backdrop-blur-sm border-b border-navy-200 sticky top-0 z-50">
        <div className="container mx-auto px-4">
          <div className="flex items-center justify-between h-16">
            <div className="flex items-center gap-8">
              <a href="/" className="nav-link-gold">Home</a>
              <a href="/track" className="nav-link-gold">Track & Trace</a>
              <a href="/services" className="nav-link-gold">Services</a>
              <a href="/quote" className="nav-link-gold">Get Quote</a>
              <a href="/merchant-register" className="nav-link-gold font-semibold active">Merchant Registration</a>
              <a href="/contact" className="nav-link-gold">Contact</a>
            </div>
            <a href="/login" className="btn-gold">Login</a>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="py-16 bg-gradient-to-r from-brand-navy via-brand-royal to-navy-800 text-white relative overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-br from-brand-gold/10 via-transparent to-brand-amber/5"></div>
        <div className="container mx-auto px-4 relative z-10">
          <div className="text-center max-w-4xl mx-auto">
            <div className="flex items-center justify-center gap-3 mb-6">
              <Building2 className="w-12 h-12 text-brand-gold" />
              <h1 className="text-4xl md:text-5xl font-display font-bold text-gradient-gold">
                Merchant Registration
              </h1>
            </div>
            <p className="text-xl text-navy-100 mb-8">
              Join Myanmar's premium logistics network. Partner with Britium Express for reliable, professional delivery services.
            </p>
            <p className="text-lg text-brand-gold">
              ကုန်သည် မှတ်ပုံတင်ခြင်း / မြန်မာ့ အဆင့်မြင့် ပို့ဆောင်ရေး ကွန်ယက်တွင် ပါဝင်ပါ
            </p>
          </div>
        </div>
      </section>

      {/* Benefits Section */}
      <section className="py-16">
        <div className="container mx-auto px-4">
          <div className="max-w-6xl mx-auto">
            <div className="text-center mb-12">
              <h2 className="text-3xl font-display font-bold text-brand-navy mb-4">
                Why Partner with Britium Express?
              </h2>
              <p className="text-navy-600 text-lg">
                Unlock premium logistics benefits for your business
              </p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-16">
              <div className="surface-card p-6 text-center">
                <div className="w-16 h-16 bg-gradient-to-br from-brand-gold to-brand-amber rounded-full flex items-center justify-center mx-auto mb-4">
                  <Truck className="w-8 h-8 text-brand-navy" />
                </div>
                <h3 className="text-xl font-bold text-brand-navy mb-2">Reliable Delivery</h3>
                <p className="text-navy-600">
                  98% success rate with real-time tracking and professional handling
                </p>
              </div>

              <div className="surface-card p-6 text-center">
                <div className="w-16 h-16 bg-gradient-to-br from-brand-navy to-brand-royal rounded-full flex items-center justify-center mx-auto mb-4">
                  <CreditCard className="w-8 h-8 text-white" />
                </div>
                <h3 className="text-xl font-bold text-brand-navy mb-2">Flexible Payment</h3>
                <p className="text-navy-600">
                  Monthly billing, credit terms, and multiple payment options available
                </p>
              </div>

              <div className="surface-card p-6 text-center">
                <div className="w-16 h-16 bg-gradient-to-br from-info to-blue-600 rounded-full flex items-center justify-center mx-auto mb-4">
                  <Shield className="w-8 h-8 text-white" />
                </div>
                <h3 className="text-xl font-bold text-brand-navy mb-2">Full Insurance</h3>
                <p className="text-navy-600">
                  Comprehensive coverage for all shipments with quick claim processing
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Registration Form */}
      <section className="py-16 bg-gradient-to-r from-navy-50 to-gold-50">
        <div className="container mx-auto px-4">
          <div className="max-w-4xl mx-auto">
            <div className="surface-elevated p-8">
              {/* Progress Steps */}
              <div className="flex items-center justify-center mb-12">
                <div className="flex items-center gap-4">
                  {[1, 2, 3, 4].map((step) => (
                    <React.Fragment key={step}>
                      <div className={`w-10 h-10 rounded-full flex items-center justify-center font-bold ${
                        step <= currentStep 
                          ? 'bg-brand-gold text-brand-navy' 
                          : 'bg-navy-200 text-navy-500'
                      }`}>
                        {step < currentStep ? <CheckCircle className="w-6 h-6" /> : step}
                      </div>
                      {step < 4 && (
                        <div className={`w-16 h-1 ${
                          step < currentStep ? 'bg-brand-gold' : 'bg-navy-200'
                        }`}></div>
                      )}
                    </React.Fragment>
                  ))}
                </div>
              </div>

              {/* Step Labels */}
              <div className="grid grid-cols-4 gap-4 mb-12 text-center text-sm">
                <div className={currentStep >= 1 ? 'text-brand-navy font-semibold' : 'text-navy-500'}>
                  Business Info
                </div>
                <div className={currentStep >= 2 ? 'text-brand-navy font-semibold' : 'text-navy-500'}>
                  Contact Details
                </div>
                <div className={currentStep >= 3 ? 'text-brand-navy font-semibold' : 'text-navy-500'}>
                  Business Details
                </div>
                <div className={currentStep >= 4 ? 'text-brand-navy font-semibold' : 'text-navy-500'}>
                  Review & Submit
                </div>
              </div>

              {/* Step 1: Business Information */}
              {currentStep === 1 && (
                <div className="space-y-6">
                  <div className="text-center mb-8">
                    <h3 className="text-2xl font-bold text-brand-navy mb-2">Business Information</h3>
                    <p className="text-navy-600">Tell us about your business</p>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                      <label className="form-label-elegant">
                        Business Name / လုပ်ငန်း အမည် *
                      </label>
                      <input
                        type="text"
                        value={formData.businessName}
                        onChange={(e) => handleInputChange('businessName', e.target.value)}
                        className="form-elegant w-full"
                        placeholder="Enter your business name"
                        required
                      />
                    </div>

                    <div>
                      <label className="form-label-elegant">
                        Business Type / လုပ်ငန်း အမျိုးအစား *
                      </label>
                      <select
                        value={formData.businessType}
                        onChange={(e) => handleInputChange('businessType', e.target.value)}
                        className="form-elegant w-full"
                        required
                      >
                        <option value="">Select business type</option>
                        {businessTypes.map((type) => (
                          <option key={type} value={type}>{type}</option>
                        ))}
                      </select>
                    </div>

                    <div>
                      <label className="form-label-elegant">
                        Business License Number / လုပ်ငန်း လိုင်စင် နံပါတ် *
                      </label>
                      <input
                        type="text"
                        value={formData.businessLicense}
                        onChange={(e) => handleInputChange('businessLicense', e.target.value)}
                        className="form-elegant w-full"
                        placeholder="Enter license number"
                        required
                      />
                    </div>

                    <div>
                      <label className="form-label-elegant">
                        Tax ID / အခွန် ID (Optional)
                      </label>
                      <input
                        type="text"
                        value={formData.taxId}
                        onChange={(e) => handleInputChange('taxId', e.target.value)}
                        className="form-elegant w-full"
                        placeholder="Enter tax ID if available"
                      />
                    </div>
                  </div>
                </div>
              )}

              {/* Step 2: Contact Information */}
              {currentStep === 2 && (
                <div className="space-y-6">
                  <div className="text-center mb-8">
                    <h3 className="text-2xl font-bold text-brand-navy mb-2">Contact Information</h3>
                    <p className="text-navy-600">Primary contact details for your account</p>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                      <label className="form-label-elegant">
                        Contact Person / ဆက်သွယ်ရမည့် ပုဂ္ဂိုလ် *
                      </label>
                      <input
                        type="text"
                        value={formData.contactPerson}
                        onChange={(e) => handleInputChange('contactPerson', e.target.value)}
                        className="form-elegant w-full"
                        placeholder="Full name of contact person"
                        required
                      />
                    </div>

                    <div>
                      <label className="form-label-elegant">
                        Position / ရာထူး *
                      </label>
                      <input
                        type="text"
                        value={formData.position}
                        onChange={(e) => handleInputChange('position', e.target.value)}
                        className="form-elegant w-full"
                        placeholder="Job title or position"
                        required
                      />
                    </div>

                    <div>
                      <label className="form-label-elegant">
                        Phone Number / ဖုန်းနံပါတ် *
                      </label>
                      <input
                        type="tel"
                        value={formData.phone}
                        onChange={(e) => handleInputChange('phone', e.target.value)}
                        className="form-elegant w-full"
                        placeholder="+95-9-XXXXXXXXX"
                        required
                      />
                    </div>

                    <div>
                      <label className="form-label-elegant">
                        Email Address / အီးမေးလ် လိပ်စာ *
                      </label>
                      <input
                        type="email"
                        value={formData.email}
                        onChange={(e) => handleInputChange('email', e.target.value)}
                        className="form-elegant w-full"
                        placeholder="business@example.com"
                        required
                      />
                    </div>
                  </div>

                  <div>
                    <label className="form-label-elegant">
                      Business Address / လုပ်ငန်း လိပ်စာ *
                    </label>
                    <textarea
                      value={formData.address}
                      onChange={(e) => handleInputChange('address', e.target.value)}
                      className="form-elegant w-full h-24"
                      placeholder="Complete business address"
                      required
                    />
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div>
                      <label className="form-label-elegant">
                        Township / မြို့နယ် *
                      </label>
                      <input
                        type="text"
                        value={formData.township}
                        onChange={(e) => handleInputChange('township', e.target.value)}
                        className="form-elegant w-full"
                        placeholder="Township"
                        required
                      />
                    </div>

                    <div>
                      <label className="form-label-elegant">
                        City / မြို့ *
                      </label>
                      <input
                        type="text"
                        value={formData.city}
                        onChange={(e) => handleInputChange('city', e.target.value)}
                        className="form-elegant w-full"
                        placeholder="City"
                        required
                      />
                    </div>

                    <div>
                      <label className="form-label-elegant">
                        Postal Code / စာတိုက် ကုဒ်
                      </label>
                      <input
                        type="text"
                        value={formData.postalCode}
                        onChange={(e) => handleInputChange('postalCode', e.target.value)}
                        className="form-elegant w-full"
                        placeholder="Postal code"
                      />
                    </div>
                  </div>
                </div>
              )}

              {/* Step 3: Business Details */}
              {currentStep === 3 && (
                <div className="space-y-6">
                  <div className="text-center mb-8">
                    <h3 className="text-2xl font-bold text-brand-navy mb-2">Business Details</h3>
                    <p className="text-navy-600">Help us understand your shipping needs</p>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                      <label className="form-label-elegant">
                        Business Category / လုပ်ငန်း အမျိုးအစား *
                      </label>
                      <select
                        value={formData.businessCategory}
                        onChange={(e) => handleInputChange('businessCategory', e.target.value)}
                        className="form-elegant w-full"
                        required
                      >
                        <option value="">Select category</option>
                        {businessCategories.map((category) => (
                          <option key={category} value={category}>{category}</option>
                        ))}
                      </select>
                    </div>

                    <div>
                      <label className="form-label-elegant">
                        Expected Monthly Volume / လစဉ် မျှော်လင့်ထားသော ပမာណ *
                      </label>
                      <select
                        value={formData.monthlyVolume}
                        onChange={(e) => handleInputChange('monthlyVolume', e.target.value)}
                        className="form-elegant w-full"
                        required
                      >
                        <option value="">Select volume range</option>
                        {monthlyVolumeOptions.map((option) => (
                          <option key={option} value={option}>{option}</option>
                        ))}
                      </select>
                    </div>

                    <div className="md:col-span-2">
                      <label className="form-label-elegant">
                        Average Package Weight / ပျမ်းမျှ ပက်ကေ့ခ် အလေးချိန်
                      </label>
                      <input
                        type="text"
                        value={formData.averagePackageWeight}
                        onChange={(e) => handleInputChange('averagePackageWeight', e.target.value)}
                        className="form-elegant w-full"
                        placeholder="e.g., 0.5-2 kg, varies, etc."
                      />
                    </div>

                    <div className="md:col-span-2">
                      <label className="form-label-elegant">
                        Special Requirements / အထူး လိုအပ်ချက်များ
                      </label>
                      <textarea
                        value={formData.specialRequirements}
                        onChange={(e) => handleInputChange('specialRequirements', e.target.value)}
                        className="form-elegant w-full h-24"
                        placeholder="Any special handling, delivery time requirements, or other needs..."
                      />
                    </div>
                  </div>
                </div>
              )}

              {/* Step 4: Review & Submit */}
              {currentStep === 4 && (
                <div className="space-y-6">
                  <div className="text-center mb-8">
                    <h3 className="text-2xl font-bold text-brand-navy mb-2">Review & Submit</h3>
                    <p className="text-navy-600">Please review your information before submitting</p>
                  </div>

                  <div className="surface-card p-6 space-y-4">
                    <h4 className="font-bold text-brand-navy text-lg mb-4">Registration Summary</h4>
                    
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
                      <div>
                        <span className="font-medium text-navy-700">Business Name:</span>
                        <div className="text-brand-navy">{formData.businessName || 'Not provided'}</div>
                      </div>
                      <div>
                        <span className="font-medium text-navy-700">Business Type:</span>
                        <div className="text-brand-navy">{formData.businessType || 'Not provided'}</div>
                      </div>
                      <div>
                        <span className="font-medium text-navy-700">Contact Person:</span>
                        <div className="text-brand-navy">{formData.contactPerson || 'Not provided'}</div>
                      </div>
                      <div>
                        <span className="font-medium text-navy-700">Phone:</span>
                        <div className="text-brand-navy">{formData.phone || 'Not provided'}</div>
                      </div>
                      <div>
                        <span className="font-medium text-navy-700">Email:</span>
                        <div className="text-brand-navy">{formData.email || 'Not provided'}</div>
                      </div>
                      <div>
                        <span className="font-medium text-navy-700">Business Category:</span>
                        <div className="text-brand-navy">{formData.businessCategory || 'Not provided'}</div>
                      </div>
                    </div>
                  </div>

                  <div className="space-y-4">
                    <div className="flex items-start gap-3">
                      <input
                        type="checkbox"
                        id="terms"
                        checked={formData.termsAccepted}
                        onChange={(e) => handleInputChange('termsAccepted', e.target.checked)}
                        className="mt-1"
                      />
                      <label htmlFor="terms" className="text-sm text-navy-600">
                        I agree to the <a href="/terms" className="text-brand-gold hover:underline">Terms and Conditions</a> and 
                        <a href="/privacy" className="text-brand-gold hover:underline ml-1">Privacy Policy</a> of Britium Express.
                      </label>
                    </div>

                    <div className="flex items-start gap-3">
                      <input
                        type="checkbox"
                        id="dataProcessing"
                        checked={formData.dataProcessingAccepted}
                        onChange={(e) => handleInputChange('dataProcessingAccepted', e.target.checked)}
                        className="mt-1"
                      />
                      <label htmlFor="dataProcessing" className="text-sm text-navy-600">
                        I consent to the processing of my personal and business data for account setup and service delivery purposes.
                      </label>
                    </div>
                  </div>
                </div>
              )}

              {/* Navigation Buttons */}
              <div className="flex justify-between items-center mt-12 pt-8 border-t border-navy-200">
                <button
                  onClick={prevStep}
                  disabled={currentStep === 1}
                  className="btn-outline-gold disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  Previous
                </button>

                <div className="text-sm text-navy-500">
                  Step {currentStep} of 4
                </div>

                {currentStep < 4 ? (
                  <button
                    onClick={nextStep}
                    className="btn-gold"
                  >
                    Next
                    <ArrowRight className="w-4 h-4 ml-2" />
                  </button>
                ) : (
                  <button
                    onClick={handleSubmit}
                    disabled={!formData.termsAccepted || !formData.dataProcessingAccepted}
                    className="btn-gold disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    Submit Registration
                    <CheckCircle className="w-4 h-4 ml-2" />
                  </button>
                )}
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Support Section */}
      <section className="py-16">
        <div className="container mx-auto px-4">
          <div className="max-w-4xl mx-auto text-center">
            <h2 className="text-3xl font-display font-bold text-brand-navy mb-4">
              Need Help with Registration?
            </h2>
            <p className="text-navy-600 text-lg mb-8">
              Our team is ready to assist you with the registration process
            </p>
            
            <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
              <div className="surface-card p-6">
                <Phone className="w-8 h-8 text-brand-gold mx-auto mb-4" />
                <h3 className="font-bold text-brand-navy mb-2">Call Us</h3>
                <p className="text-navy-600 mb-4">Speak directly with our merchant onboarding team</p>
                <a href="tel:+959897447744" className="text-brand-gold font-semibold">
                  +95-9-897447744
                </a>
              </div>

              <div className="surface-card p-6">
                <Mail className="w-8 h-8 text-brand-gold mx-auto mb-4" />
                <h3 className="font-bold text-brand-navy mb-2">Email Support</h3>
                <p className="text-navy-600 mb-4">Send us your questions and we'll respond within 24 hours</p>
                <a href="mailto:merchants@britiumexpress.com" className="text-brand-gold font-semibold">
                  merchants@britiumexpress.com
                </a>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-gradient-to-r from-brand-navy via-navy-800 to-brand-royal text-white py-12">
        <div className="container mx-auto px-4">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div>
              <h3 className="text-xl font-display font-bold text-brand-gold mb-4">Britium Express</h3>
              <p className="text-navy-200 mb-4">
                A dedicated delivery arm of Britium Ventures Company Limited. Providing fast, secure, and compliant logistics solutions.
              </p>
            </div>

            <div>
              <h4 className="font-bold text-brand-gold mb-4">Quick Links</h4>
              <div className="space-y-2">
                <a href="/track" className="block text-navy-200 hover:text-brand-gold transition-colors">Track Package</a>
                <a href="/services" className="block text-navy-200 hover:text-brand-gold transition-colors">Services</a>
                <a href="/quote" className="block text-navy-200 hover:text-brand-gold transition-colors">Get Quote</a>
              </div>
            </div>

            <div>
              <h4 className="font-bold text-brand-gold mb-4">Contact</h4>
              <div className="space-y-2 text-navy-200">
                <div className="flex items-center gap-2">
                  <MapPin className="w-4 h-4" />
                  <span>Britium Ventures Company Limited, YANGON, Yangon 11451 My.</span>
                </div>
                <div className="flex items-center gap-2">
                  <Phone className="w-4 h-4" />
                  <span>+95-9-897447744, +95-9-897447755</span>
                </div>
              </div>
            </div>
          </div>

          <div className="border-t border-navy-700 mt-8 pt-8 text-center">
            <p className="text-navy-300">
              © 2026 Britium Ventures Company Limited. All Rights Reserved.
            </p>
          </div>
        </div>
      </footer>
    </div>
  );
}