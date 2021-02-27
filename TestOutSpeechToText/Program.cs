using Microsoft.CognitiveServices.Speech;
using Microsoft.Extensions.Configuration;
using System;
using System.Threading.Tasks;

namespace TestOutSpeechToText
{
    class Program
    {
        static void Main(string[] args)
        {
            RecognizeSpeech();
            Console.ReadLine(); 
        }

        static async void RecognizeSpeech()
        {
            IConfiguration configuration = new ConfigurationBuilder().AddJsonFile("AppSettings.json").Build();
            string speech_service_key = configuration.GetSection("SpeechServiceKey").Value;
            string speech_service_region = configuration.GetSection("SpeechServiceRegion").Value;
            SpeechConfig speech_config = SpeechConfig.FromSubscription(speech_service_key, speech_service_region);
            using (SpeechRecognizer speech_recognizer = new SpeechRecognizer(speech_config))
            {
                Console.WriteLine("Say something");
                SpeechRecognitionResult result = await speech_recognizer.RecognizeOnceAsync();
                switch (result.Reason)
                {
                    case ResultReason.RecognizedSpeech:
                        Console.WriteLine(result.Text);
                        break;
                    default:
                        Console.WriteLine("Error");
                        break;
                }
            }
        }
    }
}
