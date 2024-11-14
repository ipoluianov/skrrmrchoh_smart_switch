import React, { createContext, useContext, useState, ReactNode } from 'react';

interface Setting {
  Value: string;
  Value1: string;
}

interface DocumentContextProps {
  activeTab: string;
  setActiveTab: (tab: string) => void;
  settingsTable: { [key: string]: Setting };
  updateSetting: (key: string, field: 'Value' | 'Value1', value: string) => void;
}

const DocumentContext = createContext<DocumentContextProps | undefined>(undefined);

export const useDocumentContext = () => {
  const context = useContext(DocumentContext);
  if (!context) {
    throw new Error("useDocumentContext must be used within a DocumentProvider");
  }
  return context;
};

const initialSettingsTable: { [key: string]: Setting } = Object.fromEntries([
  ...Array.from({ length: 16 }, (_, i) => [`Relay${i}`, { Value: '', Value1: '' }]),
  ...Array.from({ length: 25 }, (_, i) => [`Switch${i}`, { Value: '', Value1: '' }]),
  ['Invert', { Value: '', Value1: '' }],
  ['EscortBlock', { Value: '', Value1: '' }],
  ['EscortTime', { Value: '', Value1: '' }],
]);

export const DocumentProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [activeTab, setActiveTab] = useState<string>('ViewRelays'); // начальная вкладка
  const [settingsTable, setSettingsTable] = useState<{ [key: string]: Setting }>(initialSettingsTable);

  const updateSetting = (key: string, field: 'Value' | 'Value1', value: string) => {
    setSettingsTable((prev) => ({
      ...prev,
      [key]: {
        ...prev[key],
        [field]: value,
      },
    }));
  };

  return (
    <DocumentContext.Provider value={{ activeTab, setActiveTab, settingsTable, updateSetting }}>
      {children}
    </DocumentContext.Provider>
  );
};
