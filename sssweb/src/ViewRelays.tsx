import React, { useState, useRef, useEffect } from 'react';
import { useDocumentContext } from './DocumentContext';
import SelectionDialog, { Option } from './SelectionDialog';

const ViewRelays: React.FC = () => {
  const { relaysTable, settingsTable, updateRelayRow } = useDocumentContext();
  const [selectedCell, setSelectedCell] = useState<{ row: number; col: number } | null>(null);
  const [isEditing, setIsEditing] = useState(false);
  const [editValue, setEditValue] = useState<number>(0);
  const inputRef = useRef<HTMLInputElement>(null);
  const containerRef = useRef<HTMLDivElement>(null);
  const cellRefs = useRef<{ [key: string]: HTMLTableCellElement | null }>({});
  const isNavigating = useRef(false);
  const [isDialogOpen, setIsDialogOpen] = useState(false);

  let keys = relaysTable.map((_, index) => index);
  let columnCount = 13;

  useEffect(() => {
    if (isEditing && inputRef.current) {
      inputRef.current.focus();
    }
  }, [isEditing]);

  useEffect(() => {
    if (selectedCell && isNavigating.current) {
      const cellKey = `${selectedCell.row}-${selectedCell.col}`;
      cellRefs.current[cellKey]?.scrollIntoView({
        block: 'nearest',
        inline: 'nearest',
      });
      isNavigating.current = false;
    }
  }, [selectedCell]);

  const getCurrentOptions = (): Option[] => {
    if (selectedCell?.col === 1) {
      return [
        { Key: '0', Value: 'Down' },
        { Key: '1', Value: 'Up' },
      ];
    }
    if (selectedCell?.col === 2) {
      let result = [];
      for (let i = 0; i < 24; i++) {
        let key = i.toString();
        let value = switchNameBySwitchNumber(i);
        result.push({ Key: key, Value: value });
      }
      return result;
    }
    return [];
  }

  const openDialog = (column: number) => {
    setIsDialogOpen(true);
  }

  const closeDialog = () => {
    setIsDialogOpen(false);
    containerRef.current?.focus();
  }

  const startEditing = (initialValue: number) => {
    if (!selectedCell) return;
    if (selectedCell?.col > 0 && selectedCell?.col < 9) {
      openDialog(1);
      return;
    }

    setIsEditing(true);
    setEditValue(initialValue);
  };

  const handleConfirm = (selectedKey: string | null) => {
    if (selectedKey) {
      updateRelayRow(selectedCell!.row, { frontSwitchOn: Number.parseInt(selectedKey) });
      closeDialog();
    }
  };

  const getCurrentCellValue = () => {
    if (selectedCell) {
      return getCellValue(selectedCell.row, selectedCell.col);
    }
    return 255;
  }

  const getCellValue = (row: number, col: number): number => {
    switch (col) {
      case 1:
        return relaysTable[row].frontSwitchOn;
      case 2:
        return relaysTable[row].switchOn;
      case 3:
        return relaysTable[row].frontSwitchOff;
      case 4:
        return relaysTable[row].switchOff;
      case 5:
        return relaysTable[row].frontRelayOn;
      case 6:
        return relaysTable[row].relayOn;
      case 7:
        return relaysTable[row].frontRelayOff;
      case 8:
        return relaysTable[row].relayOff;
      case 9:
        return relaysTable[row].timeOnHour;
      case 10:
        return relaysTable[row].timeOnMinute;
      case 11:
        return relaysTable[row].timeOffHour;
      case 12:
        return relaysTable[row].timeOffMinute;
      default:
        return 255;
    }
  }

  const finishEditing = () => {
    if (selectedCell) {
      const { row, col } = selectedCell;

      switch (col) {
        case 1:
          updateRelayRow(row, { frontSwitchOn: editValue });
          break;
        case 2:
          updateRelayRow(row, { switchOn: editValue });
          break;
        case 3:
          updateRelayRow(row, { frontSwitchOff: editValue });
          break;
        case 4:
          updateRelayRow(row, { switchOff: editValue });
          break;
        case 5:
          updateRelayRow(row, { frontRelayOn: editValue });
          break;
        case 6:
          updateRelayRow(row, { relayOn: editValue });
          break;
        case 7:
          updateRelayRow(row, { frontRelayOff: editValue });
          break;
        case 8:
          updateRelayRow(row, { relayOff: editValue });
          break;
        case 9:
          updateRelayRow(row, { timeOnHour: editValue });
          break;
        case 10:
          updateRelayRow(row, { timeOnMinute: editValue });
          break;
        case 11:
          updateRelayRow(row, { timeOffHour: editValue });
          break;
        case 12:
          updateRelayRow(row, { timeOffMinute: editValue });
          break;
      }
    }
    setIsEditing(false);
    containerRef.current?.focus();
  };

  const handleKeyDown = (event: React.KeyboardEvent) => {
    if (!selectedCell) return;

    if (isDialogOpen) {
      if (event.key === 'Escape') {
        closeDialog();
      }
      event.preventDefault();
      return;
    }

    const { row, col } = selectedCell;

    if (isEditing) {
      if (event.key === 'Enter') {
        finishEditing();
      } else if (event.key === 'Escape') {
        setIsEditing(false);
        containerRef.current?.focus();
      }
    } else {
      if (event.key === 'ArrowDown' && row < keys.length - 1) {
        event.preventDefault();
        isNavigating.current = true;
        setSelectedCell({ row: row + 1, col });
      } else if (event.key === 'ArrowUp' && row > 0) {
        event.preventDefault();
        isNavigating.current = true;
        setSelectedCell({ row: row - 1, col });
      } else if (event.key === 'ArrowRight' && col < columnCount - 1) {
        event.preventDefault();
        let colToSet = col + 1;
        isNavigating.current = true;
        setSelectedCell({ row, col: colToSet });
      } else if (event.key === 'ArrowLeft' && col > 1) {
        event.preventDefault();
        let colToSet = col - 1;
        isNavigating.current = true;
        setSelectedCell({ row, col: colToSet });
      } else if (event.key === 'Enter') {
        startEditing(getCellValue(row, col));
      } else if (/^[a-zA-Z0-9]$/.test(event.key)) {
        event.preventDefault();
        Number.parseInt(event.key) >= 0 && Number.parseInt(event.key) <= 9 ? startEditing(Number.parseInt(event.key)) :
          startEditing(0);
      }
    }
  };

  const relayNameByRowIndex = (index: number): string => {
    let relayNumber = index / 8;
    relayNumber = Math.floor(relayNumber);
    return relayNameByRelayNumber(relayNumber);
  }

  const relayNameByRelayNumber = (relayNumber: number): string => {
    if (relayNumber >= 16) return ``;
    let relayKey = `Relay${relayNumber}`;
    if (settingsTable[relayKey] === undefined || settingsTable[relayKey].Value === "") return `Relay ${relayNumber}`;
    let relayName = settingsTable[relayKey].Value;
    return relayName;
  }

  const switchNameBySwitchNumber = (switchNumber: number): string => {
    if (switchNumber >= 25) return ``;

    let switchKey = `Switch${switchNumber}`;
    if (settingsTable[switchKey] === undefined || settingsTable[switchKey].Value === "") return `Switch ${switchNumber}`;
    let switchName = settingsTable[switchKey].Value;
    return switchName;
  }

  const frontNameByNumber = (number: number): string => {
    let frontKey = ``;
    if (number === 0) frontKey = `Down`;
    if (number === 1) frontKey = `Up`;
    return frontKey
  }

  return (
    <div
      ref={containerRef}
      style={{
        height: '80vh',
        overflowX: 'auto', // Горизонтальный скроллинг, если содержимое выходит за пределы
        overflowY: 'auto', // Вертикальный скроллинг
        border: '1px solid #ddd',
        borderRadius: '4px',
        outline: 'none',
      }}
      onKeyDown={handleKeyDown}
      tabIndex={0}
    >

      <table style={{ borderCollapse: 'collapse', width: 'auto' }}> {/* Устанавливаем ширину таблицы на auto */}
        <thead style={{ position: 'sticky', top: 0, backgroundColor: '#f9f9f9', zIndex: 1 }}>
          <tr>
            <th style={{ width: '300px', padding: '8px', borderBottom: '1px solid #ccc', borderRight: '1px solid #ccc' }}>Key</th>
            <th style={{ width: '100px', padding: '8px', borderBottom: '1px solid #ccc', borderLeft: '1px solid #ccc' }}>frontSwitchOn</th>
            <th style={{ width: '100px', padding: '8px', borderBottom: '1px solid #ccc', borderLeft: '1px solid #ccc' }}>switchOn</th>
            <th style={{ width: '100px', padding: '8px', borderBottom: '1px solid #ccc', borderLeft: '1px solid #ccc' }}>frontSwitchOff</th>
            <th style={{ width: '100px', padding: '8px', borderBottom: '1px solid #ccc', borderLeft: '1px solid #ccc' }}>switchOff</th>
            <th style={{ width: '100px', padding: '8px', borderBottom: '1px solid #ccc', borderLeft: '1px solid #ccc' }}>frontRelayOn</th>
            <th style={{ width: '100px', padding: '8px', borderBottom: '1px solid #ccc', borderLeft: '1px solid #ccc' }}>relayOn</th>
            <th style={{ width: '100px', padding: '8px', borderBottom: '1px solid #ccc', borderLeft: '1px solid #ccc' }}>frontRelayOff</th>
            <th style={{ width: '100px', padding: '8px', borderBottom: '1px solid #ccc', borderLeft: '1px solid #ccc' }}>relayOff</th>
            <th style={{ width: '100px', padding: '8px', borderBottom: '1px solid #ccc', borderLeft: '1px solid #ccc' }}>timeOnHour</th>
            <th style={{ width: '100px', padding: '8px', borderBottom: '1px solid #ccc', borderLeft: '1px solid #ccc' }}>timeOnMinute</th>
            <th style={{ width: '100px', padding: '8px', borderBottom: '1px solid #ccc', borderLeft: '1px solid #ccc' }}>timeOffHour</th>
            <th style={{ width: '100px', padding: '8px', borderBottom: '1px solid #ccc', borderLeft: '1px solid #ccc' }}>timeOffMinute</th>
          </tr>
        </thead>
        <tbody>
          {keys.map((key, rowIndex) => (
            <tr key={key}>
              <td
                style={{
                  width: '300px',
                  padding: '8px',
                  borderBottom: '1px solid #ccc',
                  borderRight: '1px solid #ccc',
                }}
                ref={(el) => (cellRefs.current[`${rowIndex}-Key`] = el)}
              >
                [{key}] {relayNameByRowIndex(key)}
              </td>
              <td
                style={{
                  width: '100px',
                  padding: '8px',
                  borderBottom: '1px solid #ccc',
                  borderLeft: '1px solid #ccc',
                  borderRight: '1px solid #ccc',
                  backgroundColor: selectedCell?.row === rowIndex && selectedCell.col === 1 ? '#d3d3d3' : 'transparent',
                }}
                ref={(el) => (cellRefs.current[`${rowIndex}-1`] = el)}
                onClick={() => {
                  setSelectedCell({ row: rowIndex, col: 1 });
                  setIsEditing(false);
                }}
              >
                {selectedCell?.row === rowIndex && selectedCell.col === 1 && isEditing ? (
                  <input
                    ref={inputRef}
                    type="text"
                    value={editValue}
                    onChange={(e) => {
                      let value = Number.parseInt(e.target.value);
                      if (!isNaN(value)) {
                        setEditValue(Number.parseInt(e.target.value));
                      }
                    }}
                    onBlur={() => finishEditing()}
                  />
                ) : (
                  frontNameByNumber(relaysTable[key].frontSwitchOn)
                )}
              </td>
              <td
                style={{
                  width: '100px',
                  padding: '8px',
                  borderBottom: '1px solid #ccc',
                  borderLeft: '1px solid #ccc',
                  backgroundColor: selectedCell?.row === rowIndex && selectedCell.col === 2 ? '#d3d3d3' : 'transparent',
                }}
                ref={(el) => (cellRefs.current[`${rowIndex}-2`] = el)}
                onClick={() => {
                  setSelectedCell({ row: rowIndex, col: 2 });
                  setIsEditing(false);
                }}
              >
                {selectedCell?.row === rowIndex && selectedCell.col === 2 && isEditing ? (
                  <input
                    ref={inputRef}
                    type="text"
                    value={editValue}
                    onChange={(e) => {
                      let value = Number.parseInt(e.target.value);
                      if (!isNaN(value)) {
                        setEditValue(Number.parseInt(e.target.value));
                      }
                    }}
                    onBlur={() => finishEditing()}
                  />
                ) : (
                  switchNameBySwitchNumber(relaysTable[key].switchOn)
                )}
              </td>
              <td
                style={{
                  width: '100px',
                  padding: '8px',
                  borderBottom: '1px solid #ccc',
                  borderLeft: '1px solid #ccc',
                  backgroundColor: selectedCell?.row === rowIndex && selectedCell.col === 3 ? '#d3d3d3' : 'transparent',
                }}
                ref={(el) => (cellRefs.current[`${rowIndex}-3`] = el)}
                onClick={() => {
                  setSelectedCell({ row: rowIndex, col: 3 });
                  setIsEditing(false);
                }}
              >
                {selectedCell?.row === rowIndex && selectedCell.col === 3 && isEditing ? (
                  <input
                    ref={inputRef}
                    type="text"
                    value={editValue}
                    onChange={(e) => {
                      let value = Number.parseInt(e.target.value);
                      if (!isNaN(value)) {
                        setEditValue(Number.parseInt(e.target.value));
                      }
                    }}
                    onBlur={() => finishEditing()}
                  />
                ) : (
                  frontNameByNumber(relaysTable[key].frontSwitchOff)
                )}
              </td>
              <td
                style={{
                  width: '100px',
                  padding: '8px',
                  borderBottom: '1px solid #ccc',
                  borderLeft: '1px solid #ccc',
                  backgroundColor: selectedCell?.row === rowIndex && selectedCell.col === 4 ? '#d3d3d3' : 'transparent',
                }}
                ref={(el) => (cellRefs.current[`${rowIndex}-4`] = el)}
                onClick={() => {
                  setSelectedCell({ row: rowIndex, col: 4 });
                  setIsEditing(false);
                }}
              >
                {selectedCell?.row === rowIndex && selectedCell.col === 4 && isEditing ? (
                  <input
                    ref={inputRef}
                    type="text"
                    value={editValue}
                    onChange={(e) => {
                      let value = Number.parseInt(e.target.value);
                      if (!isNaN(value)) {
                        setEditValue(Number.parseInt(e.target.value));
                      }
                    }}
                    onBlur={() => finishEditing()}
                  />
                ) : (
                  switchNameBySwitchNumber(relaysTable[key].switchOff)
                )}
              </td>
              <td
                style={{
                  width: '100px',
                  padding: '8px',
                  borderBottom: '1px solid #ccc',
                  borderLeft: '1px solid #ccc',
                  backgroundColor: selectedCell?.row === rowIndex && selectedCell.col === 5 ? '#d3d3d3' : 'transparent',
                }}
                ref={(el) => (cellRefs.current[`${rowIndex}-5`] = el)}
                onClick={() => {
                  setSelectedCell({ row: rowIndex, col: 5 });
                  setIsEditing(false);
                }}
              >
                {selectedCell?.row === rowIndex && selectedCell.col === 5 && isEditing ? (
                  <input
                    ref={inputRef}
                    type="text"
                    value={editValue}
                    onChange={(e) => {
                      let value = Number.parseInt(e.target.value);
                      if (!isNaN(value)) {
                        setEditValue(Number.parseInt(e.target.value));
                      }
                    }}
                    onBlur={() => finishEditing()}
                  />
                ) : (
                  frontNameByNumber(relaysTable[key].frontRelayOn)
                )}
              </td>
              <td
                style={{
                  width: '100px',
                  padding: '8px',
                  borderBottom: '1px solid #ccc',
                  borderLeft: '1px solid #ccc',
                  backgroundColor: selectedCell?.row === rowIndex && selectedCell.col === 6 ? '#d3d3d3' : 'transparent',
                }}
                ref={(el) => (cellRefs.current[`${rowIndex}-6`] = el)}
                onClick={() => {
                  setSelectedCell({ row: rowIndex, col: 6 });
                  setIsEditing(false);
                }}
              >
                {selectedCell?.row === rowIndex && selectedCell.col === 6 && isEditing ? (
                  <input
                    ref={inputRef}
                    type="text"
                    value={editValue}
                    onChange={(e) => {
                      let value = Number.parseInt(e.target.value);
                      if (!isNaN(value)) {
                        setEditValue(Number.parseInt(e.target.value));
                      }
                    }}
                    onBlur={() => finishEditing()}
                  />
                ) : (
                  relayNameByRelayNumber(relaysTable[key].relayOn)
                )}
              </td>
              <td
                style={{
                  width: '100px',
                  padding: '8px',
                  borderBottom: '1px solid #ccc',
                  borderLeft: '1px solid #ccc',
                  backgroundColor: selectedCell?.row === rowIndex && selectedCell.col === 7 ? '#d3d3d3' : 'transparent',
                }}
                ref={(el) => (cellRefs.current[`${rowIndex}-7`] = el)}
                onClick={() => {
                  setSelectedCell({ row: rowIndex, col: 7 });
                  setIsEditing(false);
                }}
              >
                {selectedCell?.row === rowIndex && selectedCell.col === 7 && isEditing ? (
                  <input
                    ref={inputRef}
                    type="text"
                    value={editValue}
                    onChange={(e) => {
                      let value = Number.parseInt(e.target.value);
                      if (!isNaN(value)) {
                        setEditValue(Number.parseInt(e.target.value));
                      }
                    }}
                    onBlur={() => finishEditing()}
                  />
                ) : (
                  frontNameByNumber(relaysTable[key].frontRelayOff)
                )}
              </td>
              <td
                style={{
                  width: '100px',
                  padding: '8px',
                  borderBottom: '1px solid #ccc',
                  borderLeft: '1px solid #ccc',
                  backgroundColor: selectedCell?.row === rowIndex && selectedCell.col === 8 ? '#d3d3d3' : 'transparent',
                }}
                ref={(el) => (cellRefs.current[`${rowIndex}-8`] = el)}
                onClick={() => {
                  setSelectedCell({ row: rowIndex, col: 8 });
                  setIsEditing(false);
                }}
              >
                {selectedCell?.row === rowIndex && selectedCell.col === 8 && isEditing ? (
                  <input
                    ref={inputRef}
                    type="text"
                    value={editValue}
                    onChange={(e) => {
                      let value = Number.parseInt(e.target.value);
                      if (!isNaN(value)) {
                        setEditValue(Number.parseInt(e.target.value));
                      }
                    }}
                    onBlur={() => finishEditing()}
                  />
                ) : (
                  relayNameByRelayNumber(relaysTable[key].relayOff)
                )}
              </td>
              <td
                style={{
                  width: '100px',
                  padding: '8px',
                  borderBottom: '1px solid #ccc',
                  borderLeft: '1px solid #ccc',
                  backgroundColor: selectedCell?.row === rowIndex && selectedCell.col === 9 ? '#d3d3d3' : 'transparent',
                }}
                ref={(el) => (cellRefs.current[`${rowIndex}-9`] = el)}
                onClick={() => {
                  setSelectedCell({ row: rowIndex, col: 9 });
                  setIsEditing(false);
                }}
              >
                {selectedCell?.row === rowIndex && selectedCell.col === 9 && isEditing ? (
                  <input
                    ref={inputRef}
                    type="text"
                    value={editValue}
                    onChange={(e) => {
                      let value = Number.parseInt(e.target.value);
                      if (!isNaN(value)) {
                        setEditValue(Number.parseInt(e.target.value));
                      }
                    }}
                    onBlur={() => finishEditing()}
                  />
                ) : (
                  relaysTable[key].timeOnHour
                )}
              </td>
              <td
                style={{
                  width: '100px',
                  padding: '8px',
                  borderBottom: '1px solid #ccc',
                  borderLeft: '1px solid #ccc',
                  backgroundColor: selectedCell?.row === rowIndex && selectedCell.col === 10 ? '#d3d3d3' : 'transparent',
                }}
                ref={(el) => (cellRefs.current[`${rowIndex}-10`] = el)}
                onClick={() => {
                  setSelectedCell({ row: rowIndex, col: 10 });
                  setIsEditing(false);
                }}
              >
                {selectedCell?.row === rowIndex && selectedCell.col === 10 && isEditing ? (
                  <input
                    ref={inputRef}
                    type="text"
                    value={editValue}
                    onChange={(e) => {
                      let value = Number.parseInt(e.target.value);
                      if (!isNaN(value)) {
                        setEditValue(Number.parseInt(e.target.value));
                      }
                    }}
                    onBlur={() => finishEditing()}
                  />
                ) : (
                  relaysTable[key].timeOnMinute
                )}
              </td>
              <td
                style={{
                  width: '100px',
                  padding: '8px',
                  borderBottom: '1px solid #ccc',
                  borderLeft: '1px solid #ccc',
                  backgroundColor: selectedCell?.row === rowIndex && selectedCell.col === 11 ? '#d3d3d3' : 'transparent',
                }}
                ref={(el) => (cellRefs.current[`${rowIndex}-11`] = el)}
                onClick={() => {
                  setSelectedCell({ row: rowIndex, col: 11 });
                  setIsEditing(false);
                }}
              >
                {selectedCell?.row === rowIndex && selectedCell.col === 11 && isEditing ? (
                  <input
                    ref={inputRef}
                    type="text"
                    value={editValue}
                    onChange={(e) => {
                      let value = Number.parseInt(e.target.value);
                      if (!isNaN(value)) {
                        setEditValue(Number.parseInt(e.target.value));
                      }
                    }}
                    onBlur={() => finishEditing()}
                  />
                ) : (
                  relaysTable[key].timeOffHour
                )}
              </td>
              <td
                style={{
                  width: '100px',
                  padding: '8px',
                  borderBottom: '1px solid #ccc',
                  borderLeft: '1px solid #ccc',
                  backgroundColor: selectedCell?.row === rowIndex && selectedCell.col === 12 ? '#d3d3d3' : 'transparent',
                }}
                ref={(el) => (cellRefs.current[`${rowIndex}-12`] = el)}
                onClick={() => {
                  setSelectedCell({ row: rowIndex, col: 12 });
                  setIsEditing(false);
                }}
              >
                {selectedCell?.row === rowIndex && selectedCell.col === 12 && isEditing ? (
                  <input
                    ref={inputRef}
                    type="text"
                    value={editValue}
                    onChange={(e) => {
                      let value = Number.parseInt(e.target.value);
                      if (!isNaN(value)) {
                        setEditValue(Number.parseInt(e.target.value));
                      }
                    }}
                    onBlur={() => finishEditing()}
                  />
                ) : (
                  relaysTable[key].timeOffMinute
                )}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      {isDialogOpen && (
        <SelectionDialog options={getCurrentOptions()} defaultSelectedKey={getCurrentCellValue().toString()} onConfirm={handleConfirm} onCancel={closeDialog} />
      )}
    </div>
  );
};

export default ViewRelays;
