using System;
using System.Runtime.InteropServices;

namespace CSharpClient
{
    internal class Program
    {
        // DLL fonksiyonlarını P/Invoke ile tanımlama
        [DllImport("matematik.dll", CallingConvention = CallingConvention.Cdecl)]
        public static extern int topla(int a, int b);

        [DllImport("matematik.dll", CallingConvention = CallingConvention.Cdecl)]
        public static extern int cikar(int a, int b);

        [DllImport("matematik.dll", CallingConvention = CallingConvention.Cdecl)]
        public static extern int carp(int a, int b);

        [DllImport("matematik.dll", CallingConvention = CallingConvention.Cdecl)]
        public static extern double bol(int a, int b);

        static void Main(string[] args)
        {
            Console.WriteLine("C# DLL İstemcisi (İmplisit Yükleme)");
            Console.WriteLine("====================================\n");

            try
            {
                // DLL fonksiyonlarını çağırma
                int a = 10;
                int b = 5;

                Console.WriteLine($"Topla: {a} + {b} = {topla(a, b)}");
                Console.WriteLine($"Çıkar: {a} - {b} = {cikar(a, b)}");
                Console.WriteLine($"Çarp:  {a} * {b} = {carp(a, b)}");
                Console.WriteLine($"Böl:   {a} / {b} = {bol(a, b)}");

                // 0'a bölme testi
                Console.WriteLine("\nSıfıra bölme testi:");
                Console.WriteLine($"Böl: 10 / 0 = {bol(10, 0)}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Hata: {ex.Message}");
                if (ex.InnerException != null)
                    Console.WriteLine($"İç Hata: {ex.InnerException.Message}");
            }

            Console.WriteLine("\nDevam etmek için bir tuşa basın...");
            Console.ReadKey();
        }
    }
} 