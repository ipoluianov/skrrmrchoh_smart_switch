using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace SkrrmrchohSmartSwitch
{
    public class EEPROM
    {
        // 16 Header
        // 32 * 16 Lines
        // Total 528
        List<byte> content = new List<byte>();
        List<byte> originalContent = new List<byte>();

        public const int CountOfRows = 63;
        public const int EEPROMSize = 16 + (CountOfRows * 16);

        public EEPROM()
        {
            content.Clear();
            for (int i = 0; i < EEPROMSize; i++)
                content.Add(0xFF);
        }

        public List<byte> SettingsRow()
        {
            List<byte> result = new List<byte>();
            for (int i = 0; i < 16; i++)
            {
                int offset = i;
                if (offset >= content.Count)
                    result.Add(0xFF);
                else
                    result.Add(content[offset]);
            }
            return result;
        }


        public List<byte> Row(int lineIndex)
        {
            List<byte> result = new List<byte>();
            for (int i = 0; i < 16; i++)
            {
                int offset = 16 + 16 * lineIndex + i;
                if (offset >= content.Count)
                    result.Add(0xFF);
                else
                    result.Add(content[offset]);
            }
            return result;
        }

        public void Set(int lineIndex, int byteIndex, byte b)
        {
            int offset = 16 + 16 * lineIndex + byteIndex;

            if (offset >= content.Count)
                while (content.Count < offset + 1)
                    content.Add(0xFF);

            content[16 + lineIndex * 16 + byteIndex] = b;
        }

        public void SetSettings(int byteIndex, byte b)
        {
            int offset = byteIndex;

            if (offset >= content.Count)
                while (content.Count < offset + 1)
                    content.Add(0xFF);

            content[byteIndex] = b;
        }

        public void SaveToFile(string fileName)
        {
            using (var fs = new FileStream(fileName, FileMode.Create, FileAccess.Write))
            {
                fs.Write(content.ToArray(), 0, content.ToArray().Length);
            }
            originalContent.Clear();
            foreach (var b in content)
                originalContent.Add(b);
        }

        public void LoadFromFile()
        {
            OpenFileDialog dialog = new OpenFileDialog();
            dialog.Filter = "EEPROM files (*.eeprom)|*.eeprom";
            DialogResult result = dialog.ShowDialog();
            if (result == DialogResult.OK)
            {
                LoadFromFile(dialog.FileName);
            }
        }

        public void SaveToFile()
        {
            SaveFileDialog dialog = new SaveFileDialog();
            dialog.Filter = "EEPROM files (*.eeprom)|*.eeprom";
            DialogResult result = dialog.ShowDialog();
            if (result == DialogResult.OK)
            {
                SaveToFile(dialog.FileName);
            }
        }

        public void LoadFromFile(string fileName)
        {
            var bs = File.ReadAllBytes(fileName);
            content.Clear();
            content.AddRange(bs);

            originalContent.Clear();
            foreach (var b in content)
                originalContent.Add(b);
        }
    }
}
