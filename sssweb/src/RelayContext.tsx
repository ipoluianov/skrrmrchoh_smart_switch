// RelayContext.tsx
import React, { createContext, useContext, useState, ReactNode } from 'react';

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

interface RelayContextProps {
  relaysTable: RelayRow[];
  updateRelayRow: (index: number, data: Partial<RelayRow>) => void;
}

const RelayContext = createContext<RelayContextProps | undefined>(undefined);

export const useRelayContext = () => {
  const context = useContext(RelayContext);
  if (!context) {
    throw new Error("useRelayContext must be used within a RelayProvider");
  }
  return context;
};

export const RelayProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [relaysTable, setRelaysTable] = useState<RelayRow[]>(
    Array.from({ length: 16 * 8 }, () => ({
      frontSwitchOn: 0,
      switchOn: 0,
      frontSwitchOff: 0,
      switchOff: 0,
      frontRelayOn: 0,
      relayOn: 0,
      frontRelayOff: 0,
      relayOff: 0,
      timeOnHour: 0,
      timeOnMinute: 0,
      timeOffHour: 0,
      timeOffMinute: 0,
    }))
  );

  const updateRelayRow = (index: number, data: Partial<RelayRow>) => {
    setRelaysTable((prev) => {
      const updated = [...prev];
      updated[index] = { ...updated[index], ...data };
      return updated;
    });
  };

  return (
    <RelayContext.Provider value={{ relaysTable, updateRelayRow }}>
      {children}
    </RelayContext.Provider>
  );
};
