import React, { createContext, useContext, useState, ReactNode } from 'react';

interface Setting {
  Value: string;
  Value1: string;
}

interface RelayRow {
  frontSwitchOn: number;
  switchOn: number;
  frontSwitchOff: number;
  switchOff: number;
  frontRelayOn: number;
  relayOn: number;
  frontRelayOff: number;
  relayOff: number;
  timeOnHour: number;
  timeOnMinute: number;
  timeOffHour: number;
  timeOffMinute: number;
}

interface DocumentContextProps {
  activeTab: string;
  setActiveTab: (tab: string) => void;
  settingsTable: { [key: string]: Setting };
  updateSetting: (key: string, field: 'Value' | 'Value1', value: string) => void;
  relaysTable: RelayRow[];
  updateRelayRow: (index: number, data: Partial<RelayRow>) => void;  
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

const initializeRelaysTable = (rows: number): RelayRow[] => {
  return Array.from({ length: rows }, () => ({
    frontSwitchOn: 255,
    switchOn: 255,
    frontSwitchOff: 255,
    switchOff: 255,
    frontRelayOn: 255,
    relayOn: 255,
    frontRelayOff: 255,
    relayOff: 255,
    timeOnHour: 255,
    timeOnMinute: 255,
    timeOffHour: 255,
    timeOffMinute: 255,
  }));
};

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

  const [relaysTable, setRelaysTable] = useState<RelayRow[]>( initializeRelaysTable(8*16) ); 

  const updateRelayRow = (index: number, data: Partial<RelayRow>) => {
    setRelaysTable((prev) => {
      const updated = [...prev];
      updated[index] = { ...updated[index], ...data };
      return updated;
    });
  };

  return (
    <DocumentContext.Provider value={{ activeTab, setActiveTab, settingsTable, updateSetting, relaysTable, updateRelayRow }}>
      {children}
    </DocumentContext.Provider>
  );
};
